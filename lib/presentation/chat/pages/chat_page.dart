import 'dart:async';

import 'package:slack_clone_gautam_manwani/core/constants/size_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/string_constants.dart';
import 'package:slack_clone_gautam_manwani/core/utils/app_injector.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/channel_entity.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/channel_repository.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_bloc.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_state.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/bloc/chat_bloc.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/bloc/chat_event.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/bloc/chat_state.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/widgets/message_input.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/widgets/message_list.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Chat page for viewing and sending messages in a channel
class ChatPage extends StatefulWidget {
  final String workspaceId;
  final ChannelEntity channel;

  const ChatPage({
    super.key,
    required this.workspaceId,
    required this.channel,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  Timer? _typingTimer;
  bool _isTyping = false;

  String? _currentUserId;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();

    // Get current user
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUserId = authState.user.id;
      _currentUserName = authState.user.name;

      // Mark channel as read when user opens it
      final channelRepository = AppInjector.get<ChannelRepository>();
      channelRepository.markAsRead(
        widget.workspaceId,
        widget.channel.id,
        authState.user.id,
      );
    }

    // Subscribe to messages
    context.read<ChatBloc>().add(
          ChatMessagesSubscribed(
            workspaceId: widget.workspaceId,
            channelId: widget.channel.id,
          ),
        );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _typingTimer?.cancel();

    // Note: Don't use context.read in dispose() - widget is already unmounted
    // The typing status will auto-expire after 5 seconds anyway
    // The stream subscriptions are cleaned up in ChatBloc.close()

    super.dispose();
  }

  void _handleTyping() {
    if (_currentUserId == null) return;

    // Cancel existing timer
    _typingTimer?.cancel();

    // Set typing to true if not already
    if (!_isTyping) {
      _isTyping = true;
      context.read<ChatBloc>().add(
            ChatTypingUpdated(
              workspaceId: widget.workspaceId,
              userId: _currentUserId!,
              userName: _currentUserName!,
              channelId: widget.channel.id,
              isTyping: true,
            ),
          );
    }

    // Set timer to stop typing after 3 seconds of inactivity
    _typingTimer = Timer(const Duration(seconds: 3), () {
      _isTyping = false;
      context.read<ChatBloc>().add(
            ChatTypingUpdated(
              workspaceId: widget.workspaceId,
              userId: _currentUserId!,
              userName: _currentUserName!,
              channelId: widget.channel.id,
              isTyping: false,
            ),
          );
    });
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    if (_currentUserId == null || _currentUserName == null) return;

    final text = _messageController.text.trim();
    _messageController.clear();

    // Stop typing
    _isTyping = false;
    _typingTimer?.cancel();
    context.read<ChatBloc>().add(
          ChatTypingUpdated(
            workspaceId: widget.workspaceId,
            userId: _currentUserId!,
            userName: _currentUserName!,
            channelId: widget.channel.id,
            isTyping: false,
          ),
        );

    // Send message
    context.read<ChatBloc>().add(
          ChatMessageSent(
            workspaceId: widget.workspaceId,
            channelId: widget.channel.id,
            text: text,
            userId: _currentUserId!,
            userName: _currentUserName!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.name),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(StringC.error),
                        const SizedBox(height: SizeC.paddingM),
                        Text(state.message),
                      ],
                    ),
                  );
                }

                if (state is ChatLoaded) {
                  return MessageList(
                    messages: state.messages,
                    currentUserId: _currentUserId ?? '',
                    workspaceId: widget.workspaceId,
                    channelId: widget.channel.id,
                  );
                }

                return const Center(child: Text(StringC.loading));
              },
            ),
          ),

          // Typing indicator
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoaded && state.typingUsers.isNotEmpty) {
                return TypingIndicator(typingUsers: state.typingUsers);
              }
              return const SizedBox.shrink();
            },
          ),

          // Message input
          MessageInput(
            controller: _messageController,
            onChanged: (_) => _handleTyping(),
            onSend: _handleSendMessage,
          ),
        ],
      ),
    );
  }
}

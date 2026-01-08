import 'package:flutter/material.dart';
import 'package:slack_clone_gautam_manwani/core/constants/string_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/size_constants.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/message_entity.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/widgets/message_bubble.dart';

/// Message list widget with auto-scroll and message grouping
class MessageList extends StatefulWidget {
  final List<MessageEntity> messages;
  final String currentUserId;
  final String workspaceId;
  final String channelId;

  const MessageList({
    super.key,
    required this.messages,
    required this.currentUserId,
    required this.workspaceId,
    required this.channelId,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();
  bool _isAutoScrollEnabled = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Auto-scroll to bottom when new messages arrive
    if (widget.messages.length != oldWidget.messages.length &&
        _isAutoScrollEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _handleScroll() {
    // Disable auto-scroll if user scrolls up
    if (_scrollController.hasClients) {
      final isAtBottom = _scrollController.position.pixels ==
          _scrollController.position.minScrollExtent;
      if (_isAutoScrollEnabled != isAtBottom) {
        setState(() {
          _isAutoScrollEnabled = isAtBottom;
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Check if messages should be grouped (same sender, within 5 minutes)
  bool _shouldGroupMessages(MessageEntity current, MessageEntity? previous) {
    if (previous == null) return false;
    if (current.senderId != previous.senderId) return false;

    final timeDiff = current.timestamp.difference(previous.timestamp);
    return timeDiff.inMinutes < 5;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return const Center(
        child: Text(StringC.noMessagesPlaceholder),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          reverse: true, // Show newest messages at bottom
          padding: const EdgeInsets.all(SizeC.paddingM),
          itemCount: widget.messages.length,
          itemBuilder: (context, index) {
            final message = widget.messages[index];
            final previousMessage =
                index < widget.messages.length - 1
                    ? widget.messages[index + 1]
                    : null;

            final shouldGroup = _shouldGroupMessages(message, previousMessage);

            return MessageBubble(
              message: message,
              isCurrentUser: message.senderId == widget.currentUserId,
              showSenderInfo: !shouldGroup,
              workspaceId: widget.workspaceId,
              channelId: widget.channelId,
              currentUserId: widget.currentUserId,
            );
          },
        ),

        // Scroll to bottom button (when not at bottom)
        if (!_isAutoScrollEnabled)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: _scrollToBottom,
              child: const Icon(Icons.arrow_downward),
            ),
          ),
      ],
    );
  }
}

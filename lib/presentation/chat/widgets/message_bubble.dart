import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slack_clone_gautam_manwani/core/constants/string_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/size_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/color_constants.dart';
import 'package:slack_clone_gautam_manwani/core/extensions/context_extensions.dart';
import 'package:slack_clone_gautam_manwani/core/extensions/date_extensions.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/message_entity.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/bloc/chat_bloc.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/bloc/chat_event.dart';

// Message bubble with reactions
class MessageBubble extends StatefulWidget {
  final MessageEntity message;
  final bool isCurrentUser;
  final bool showSenderInfo;
  final String workspaceId;
  final String channelId;
  final String currentUserId;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.showSenderInfo,
    required this.workspaceId,
    required this.channelId,
    required this.currentUserId,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  // Optimistic reactions for instant UI update
  List<ReactionEntity> _reactns = [];

  @override
  void initState() {
    super.initState();
    _reactns = List.from(widget.message.reactions);
  }

  @override
  void didUpdateWidget(MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync with stream updates
    if (widget.message.reactions != oldWidget.message.reactions) {
      _reactns = List.from(widget.message.reactions);
    }
  }

  void _handleReactionTap(String emoji, bool hasCurrentUserReacted) {
    // Optimistic UI update (instant)
    setState(() {
      if (hasCurrentUserReacted) {
        // Remove reaction locally
        _reactns.removeWhere(
          (r) => r.emoji == emoji && r.userId == widget.currentUserId,
        );
      } else {
        // Add reaction locally
        _reactns.add(
          ReactionEntity(
            emoji: emoji,
            userId: widget.currentUserId,
            userName: 'Me',
          ),
        );
      }
    });

    // Send to Firestore (will sync via stream later)
    if (hasCurrentUserReacted) {
      context.read<ChatBloc>().add(
        ChatReactionRemoved(
          workspaceId: widget.workspaceId,
          channelId: widget.channelId,
          messageId: widget.message.id,
          userId: widget.currentUserId,
          emoji: emoji,
        ),
      );
    } else {
      context.read<ChatBloc>().add(
        ChatReactionAdded(
          workspaceId: widget.workspaceId,
          channelId: widget.channelId,
          messageId: widget.message.id,
          emoji: emoji,
          userId: widget.currentUserId,
          userName: 'Me',
        ),
      );
    }
  }

  void _handleBubbleTap() {
    // Check if current user has any reactions on this message
    final currentUserReactions = _reactns
        .where((r) => r.userId == widget.currentUserId)
        .toList();

    if (currentUserReactions.isEmpty) return;

    // Remove all current user's reactions
    for (final reaction in currentUserReactions) {
      _handleReactionTap(reaction.emoji, true);
    }
  }

  void _showReactionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(SizeC.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringC.addReaction,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: SizeC.paddingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ReactionButton(
                  emoji: StringC.thumbsUp,
                  onTap: () {
                    _handleReactionTap(StringC.thumbsUp, false);
                    Navigator.pop(context);
                  },
                ),
                _ReactionButton(
                  emoji: StringC.heart,
                  onTap: () {
                    _handleReactionTap(StringC.heart, false);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: widget.showSenderInfo ? SizeC.paddingM : SizeC.paddingXS,
        bottom: SizeC.paddingXS,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: widget.isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: widget.isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Sender name and timestamp
                if (widget.showSenderInfo)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: SizeC.paddingS,
                      right: SizeC.paddingS,
                      bottom: SizeC.paddingXS,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.message.senderName,
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: SizeC.paddingS),
                        Text(
                          widget.message.timestamp.toDisplayTime(),
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            color: context.colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Message bubble with reactions on top
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Message bubble
                    GestureDetector(
                      onTap: _handleBubbleTap,
                      onLongPress: () => _showReactionMenu(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SizeC.messageBubblePadding,
                          vertical: SizeC.paddingS,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isCurrentUser
                              ? ColorC.slackPurple
                              : context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(SizeC.radiusL),
                        ),
                        child: Text(
                          widget.message.text,
                          style: TextStyle(
                            color: widget.isCurrentUser
                                ? Colors.white
                                : context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),

                    // Reactions positioned on top
                    if (_reactns.isNotEmpty)
                      Positioned(
                        bottom: -8,
                        right: widget.isCurrentUser ? 0 : null,
                        left: widget.isCurrentUser ? null : 0,
                        child: Wrap(
                          spacing: 4,
                          children: _buildReactions(context),
                        ),
                      ),
                  ],
                ),

                // Add spacing if reactions exist
                if (_reactns.isNotEmpty) const SizedBox(height: 12),

                // Message status (for current user)
                if (widget.isCurrentUser &&
                    widget.message.status != MessageStatus.sent)
                  Padding(
                    padding: const EdgeInsets.only(top: SizeC.paddingXS),
                    child: Text(
                      widget.message.status == MessageStatus.sending
                          ? StringC.sending
                          : StringC.failed,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: widget.message.status == MessageStatus.failed
                            ? ColorC.messageFailed
                            : ColorC.messagePending,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReactions(BuildContext context) {
    final Map<String, List<ReactionEntity>> groupedReactions = {};

    // Use optimistic reactions instead of message.reactions
    for (final reaction in _reactns) {
      groupedReactions.putIfAbsent(reaction.emoji, () => []).add(reaction);
    }

    return groupedReactions.entries.map((entry) {
      final emoji = entry.key;
      final reactions = entry.value;
      final count = reactions.length;
      final hasCurrentUserReacted = reactions.any(
        (r) => r.userId == widget.currentUserId,
      );

      return GestureDetector(
        onTap: () => _handleReactionTap(emoji, hasCurrentUserReacted),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          decoration: BoxDecoration(
            color: hasCurrentUserReacted
                ? ColorC.slackPurple.withAlpha(128)
                : context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(SizeC.radiusRound),
            border: Border.all(
              color: hasCurrentUserReacted
                  ? ColorC.slackPurple
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 12)),
              if (count > 1) ...[
                const SizedBox(width: 4),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _ReactionButton extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;

  const _ReactionButton({required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(SizeC.radiusM),
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
      ),
    );
  }
}

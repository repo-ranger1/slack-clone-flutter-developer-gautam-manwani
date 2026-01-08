import 'package:flutter/material.dart';
import 'package:slack_clone_gautam_manwani/core/constants/color_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/size_constants.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/channel_entity.dart';

/// Channel tile widget for displaying a channel in the list
class ChannelTile extends StatelessWidget {
  final ChannelEntity channel;
  final VoidCallback onTap;

  const ChannelTile({super.key, required this.channel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: channel.isActive
              ? ColorC.slackPurple
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(SizeC.radiusM),
        ),
        child: Icon(
          Icons.tag,
          color: channel.isActive
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      title: Text(
        channel.name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: channel.isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: channel.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ColorC.unreadBadge,
                borderRadius: BorderRadius.circular(SizeC.radiusRound),
              ),
              child: Text(
                channel.unreadCount > 99 ? '99+' : '${channel.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      selected: channel.isActive,
      selectedTileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      onTap: onTap,
    );
  }
}

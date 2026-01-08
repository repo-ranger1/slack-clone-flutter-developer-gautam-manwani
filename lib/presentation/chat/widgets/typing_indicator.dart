import 'package:flutter/material.dart';
import 'package:slack_clone_gautam_manwani/core/constants/string_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/size_constants.dart';

/// Typing indicator widget showing who is typing
class TypingIndicator extends StatelessWidget {
  final List<String> typingUsers;

  const TypingIndicator({
    super.key,
    required this.typingUsers,
  });

  String _getTypingText() {
    if (typingUsers.isEmpty) return '';

    if (typingUsers.length == 1) {
      return '${typingUsers[0]} ${StringC.isTyping}';
    } else if (typingUsers.length == 2) {
      return '${typingUsers[0]} and ${typingUsers[1]} ${StringC.areTyping}';
    } else {
      return 'Several people ${StringC.areTyping}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeC.paddingM,
        vertical: SizeC.paddingS,
      ),
      child: Row(
        children: [
          // Animated dots
          _AnimatedDots(),
          const SizedBox(width: SizeC.paddingS),

          // Typing text
          Expanded(
            child: Text(
              _getTypingText(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(153),
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated dots for typing indicator
class _AnimatedDots extends StatefulWidget {
  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) {
            final del = i * 0.2;
            final val = (_ctrl.value - del).clamp(0.0, 1.0);
            final op = (Curves.easeInOut.transform(val) * 2 - 1).abs();

            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(77 + (op * 102).toInt()),
              ),
            );
          },
        );
      }),
    );
  }
}

import 'package:slack_clone_gautam_manwani/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:slack_clone_gautam_manwani/core/constants/string_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/size_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/color_constants.dart';

/// Modern message input widget for composing messages
class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSend,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _hasTxt = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final txt = widget.controller.text.trim().isNotEmpty;
    if (txt != _hasTxt) {
      setState(() {
        _hasTxt = txt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: SizeC.paddingS,
        right: SizeC.paddingS,
        top: SizeC.paddingS,
        bottom: MediaQuery.of(context).viewInsets.bottom + SizeC.paddingS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 77 : 13),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text input field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: SizeC.paddingL),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          controller: widget.controller,
                          decoration: InputDecoration(
                            hintText: StringC.typeMessage,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: SizeC.paddingS,
                            ),
                            fillColor:
                                context.colorScheme.surfaceContainerHighest,
                            hintStyle: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(128),
                            ),
                          ),
                          onSubmitted: (v) => widget.onSend(),
                          textInputAction: TextInputAction.go,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: widget.onChanged,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: SizeC.paddingL),
                  ],
                ),
              ),
            ),
            const SizedBox(width: SizeC.paddingS),

            // Send button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Material(
                color: _hasTxt
                    ? ColorC.slackPurple
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: _hasTxt ? widget.onSend : null,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.send_rounded,
                        key: ValueKey(_hasTxt),
                        color: _hasTxt
                            ? Colors.white
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(77),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

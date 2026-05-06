import 'package:flutter/material.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/about/presentation/widgets/about_content.dart';

class OnosendaiAboutDialog extends StatelessWidget {
  const OnosendaiAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final height = MediaQuery.sizeOf(context).height;

    return Dialog(
      backgroundColor: theme.background,
      child: Container(
        width: 520,
        constraints: BoxConstraints(maxHeight: height * 0.86),
        decoration: BoxDecoration(
          color: theme.background,
          border: Border.all(color: theme.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ABOUT',
                    style: theme.mainFont.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      '[ESC]',
                      style: theme.mainFont.copyWith(
                        color: theme.dimmed,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: theme.border),
            const Flexible(
              child: AboutContent(padding: EdgeInsets.fromLTRB(24, 24, 24, 32)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutDialogButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _AboutDialogButton({required this.label, required this.onTap});

  @override
  State<_AboutDialogButton> createState() => _AboutDialogButtonState();
}

class _AboutDialogButtonState extends State<_AboutDialogButton> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: theme.background,
            border: Border.all(
              color: _hovered ? theme.foreground : theme.dimmed,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.mainFont.copyWith(fontSize: 13, letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}

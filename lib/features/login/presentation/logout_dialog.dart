import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class LogoutDialog extends ConsumerStatefulWidget {
  const LogoutDialog({super.key});

  @override
  ConsumerState<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends ConsumerState<LogoutDialog> {
  var _isLoggingOut = false;

  Future<void> _confirmLogout() async {
    setState(() => _isLoggingOut = true);
    await ref.read(authTokensProvider.notifier).clear();

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Dialog(
      backgroundColor: theme.dialogBackground,
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          color: theme.dialogBackground,
          border: Border.all(color: theme.dialogBorder),
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
                    'LOG OUT',
                    style: theme.mainFont.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  GestureDetector(
                    onTap: _isLoggingOut
                        ? null
                        : () => Navigator.of(context).pop(false),
                    child: Text(
                      '[ESC]',
                      style: theme.mainFont.copyWith(
                        color: theme.metaText,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: theme.divider),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Are you sure you want to log out?',
                    style: theme.mainFont.copyWith(fontSize: 14, height: 1.35),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _LogoutDialogButton(
                          label: 'Cancel',
                          onTap: _isLoggingOut
                              ? null
                              : () => Navigator.of(context).pop(false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LogoutDialogButton(
                          label: 'Log out',
                          isLoading: _isLoggingOut,
                          onTap: _isLoggingOut ? null : _confirmLogout,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutDialogButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onTap;

  const _LogoutDialogButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  State<_LogoutDialogButton> createState() => _LogoutDialogButtonState();
}

class _LogoutDialogButtonState extends State<_LogoutDialogButton> {
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
            color: theme.dialogBackground,
            border: Border.all(
              color: widget.onTap == null
                  ? theme.secondaryButtonBorder
                  : _hovered
                  ? theme.headingText
                  : theme.secondaryButtonBorder,
            ),
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? SizedBox.square(
                  dimension: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: theme.actionIcon,
                  ),
                )
              : Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.mainFont.copyWith(
                    fontSize: 13,
                    letterSpacing: 1.5,
                  ),
                ),
        ),
      ),
    );
  }
}

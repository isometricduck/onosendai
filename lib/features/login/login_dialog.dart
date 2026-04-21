import 'package:flutter/material.dart';
import 'package:onosendai/core/theme/theme.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _emailController = TextEditingController(
    text: 'netizen@cyberspace.online',
  );
  final _passwordController = TextEditingController(text: '········');
  bool _obscurePassword = true;

  //static const _bg = Color(0xFF0D0F0B);
  //static const _surface = Color(0xFF141610);
  //static const _border = Color(0xFF2A2D24);
  //static const _textPrimary = Color(0xFFD4D9C8);
  //static const _textMuted = Color(0xFF6B7160);
  //static const _accent = Color(0xFFB8C49A);
  //static const _inputBg = Color(0xFF1A1D16);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.theme.background,
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: context.theme.background,
          border: Border.all(color: context.theme.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.theme.foreground,
                      letterSpacing: 2.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      '[ESC]',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: context.theme.dimmed,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(height: 1, thickness: 1, color: context.theme.border),

            // Form
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Email field
                  _FieldLabel(label: 'Email'),
                  const SizedBox(height: 8),
                  _LoginTextField(
                    controller: _emailController,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  _FieldLabel(label: 'Password'),
                  const SizedBox(height: 8),
                  _LoginTextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffix: GestureDetector(
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: context.theme.dimmed,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: context.theme.foreground,
                          decoration: TextDecoration.underline,
                          decorationColor: context.theme.foreground,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login button
                  _LoginButton(label: 'Login', onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        color: context.theme.foreground,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _LoginTextField({
    required this.controller,
    required this.obscureText,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.background,
        border: Border.all(color: context.theme.border, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: context.theme.foreground,
          letterSpacing: 0.3,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: InputBorder.none,
          suffixIcon: suffix != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffix,
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
        cursorColor: context.theme.foreground,
      ),
    );
  }
}

class _LoginButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _LoginButton({required this.label, required this.onTap});

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: context.theme.background,
            border: Border.all(
              color: _hovered ? context.theme.foreground : context.theme.dimmed,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: context.theme.foreground,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/login/presentation/riverpod/login_providers.dart';

class LoginDialog extends ConsumerStatefulWidget {
  const LoginDialog({super.key});

  @override
  ConsumerState<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends ConsumerState<LoginDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _emailError = false;
  bool _passwordError = false;

  static final _emailPattern = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$",
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    bool emailError = false;
    bool passwordError = false;
    FocusNode? focusNode;

    if (email.isEmpty) {
      emailError = true;
      focusNode = _emailFocusNode;
    } else if (!_emailPattern.hasMatch(email)) {
      emailError = true;
      focusNode = _emailFocusNode;
    }

    if (password.isEmpty) {
      passwordError = true;
      focusNode ??= _passwordFocusNode;
    }

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

    focusNode?.requestFocus();
    return !emailError && !passwordError;
  }

  Future<void> _handleLogin() async {
    if (!_validate()) {
      return;
    }

    await ref
        .read(loginNotifierProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthTokens?>>(authTokensProvider, (_, next) {
      if (next.valueOrNull != null && context.mounted) {
        Navigator.of(context).pop();
      }
    });

    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState.isLoading;
    final error = loginState.error;
    String? errorMessage;
    if (loginState.hasError) {
      errorMessage = error != null
          ? error.toString()
          : 'Login failed. Please try again.';
    }

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
                    onTap: isLoading ? null : () => Navigator.of(context).pop(),
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
                    focusNode: _emailFocusNode,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) {
                      if (_emailError) {
                        setState(() => _emailError = false);
                      }
                    },
                    onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  _FieldLabel(label: 'Password'),
                  const SizedBox(height: 8),
                  _LoginTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) {
                      if (_passwordError) {
                        setState(() => _passwordError = false);
                      }
                    },
                    onSubmitted: (_) {
                      if (!isLoading) {
                        _handleLogin();
                      }
                    },
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

                  const SizedBox(height: 20),

                  // Login button
                  _LoginButton(
                    label: 'Login',
                    isLoading: isLoading,
                    onTap: isLoading ? null : _handleLogin,
                  ),

                  // Error message
                  if (errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: context.theme.foreground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
  final FocusNode focusNode;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  const _LoginTextField({
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.background,
            border: Border.all(
              color: context.theme.border,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
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
        ),
      ],
    );
  }
}

class _LoginButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onTap;

  const _LoginButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

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
              color: widget.isLoading
                  ? context.theme.dimmed
                  : _hovered
                  ? context.theme.foreground
                  : context.theme.dimmed,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: context.theme.dimmed,
                  ),
                )
              : Text(
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

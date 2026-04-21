import 'package:flutter/material.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/login/login_dialog.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: _HomePage());
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.theme.background,
        child: Center(
          child: ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const LoginDialog(),
            ),
            child: const Text('Login'),
          ),
        ),
      ),
    );
  }
}

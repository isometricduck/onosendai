import 'package:flutter/material.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

void showErrorSnackBar(BuildContext context, String message) {
  final theme = context.cyberTheme;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: theme.mainFont.copyWith(color: theme.snackbarText),
      ),
      backgroundColor: theme.snackbarBackground,
    ),
  );
}

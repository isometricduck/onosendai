import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Colors;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class CryptTheme extends Theme {
  @override
  bool get isDark => true;

  @override
  IconData get icon => LucideIcons.skull;

  @override
  Color get foreground => Color(int.parse('#ee1100'.replaceAll('#', '0xFF')));

  @override
  Color get background => Color(int.parse('#100202'.replaceAll('#', '0xFF')));

  @override
  Color get border => Colors.red.withValues(alpha: 0.3);

  @override
  Color get dimmed => Colors.red.withValues(alpha: 0.8);

  @override
  TextStyle get font => TextStyle(
    fontFamily: 'GeistMono',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.12,
  );
}

/*

[data-theme=crypt] {
    --font-size-base: 14px;
    --font-size-base-mobile: 16px;
    --font-size-h: 14px;
    --font-size-h-mobile: 16px;
    --font-size-p: 14px;
    --font-size-p-mobile: 14px;
    --line-height-base: 1.36;
    --letter-spacing-base: .012rem;
    --color-bg: #100202;
    --color-fg: #e10;
    --color-fg-dim: rgba(255,0,0,.8);
    --color-border: rgba(255,0,0,.3);
    --color-quote: rgba(255,0,0,.1);
    --color-blockquote-bg: rgba(255,0,0,0);
    --color-code-bg: rgba(255,0,0,0);
    --radius-lg: 4px;
    --radius-md: 3px;
    --radius-sm: 2x;
    --color-code: red;
    --theme-font-mono: Geist Mono,monospace;
    --code-font: Geist Mono,monospace;
    --text-shadow-color: rgba(255,0,0,.46);
    --text-shadow-color-dim: rgba(255,0,0,.25);
    --border-w: 1.75px
}

*/

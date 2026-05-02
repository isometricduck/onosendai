import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class GridTheme extends Theme {
  @override
  bool get isDark => true;

  @override
  IconData get icon => LucideIcons.grid;

  @override
  Color get foreground => Color(int.parse('#ff9810'.replaceAll('#', '0xFF')));

  @override
  Color get background => Color(int.parse('#120900'.replaceAll('#', '0xFF')));

  @override
  Color get border => Color(
    int.parse('#ff9810'.replaceAll('#', '0xFF')),
  ).withValues(alpha: 0.22);

  @override
  Color get dimmed => Color(
    int.parse('#ff9810'.replaceAll('#', '0xFF')),
  ).withValues(alpha: 0.6);

  @override
  TextStyle get font => TextStyle(
    fontFamily: 'ShareTechMono',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

/*

[data-theme=grid] {
    --font-size-base: 16px;
    --font-size-base-mobile: 18px;
    --font-size-h: 16px;
    --font-size-h-mobile: 18px;
    --font-size-p: 16px;
    --font-size-p-mobile: 16px;
    --line-height-base: 1.3;
    --letter-spacing-base: -.015rem;
    --color-bg: #120900;
    --color-fg: #ff9810;
    --color-fg-dim: rgba(255,152,16,.6);
    --color-border: rgba(255,152,16,.22);
    --color-quote: rgba(255,152,16,.12);
    --color-blockquote-bg: rgba(255,152,16,.05);
    --color-code-bg: rgba(255,152,16,.08);
    --radius-lg: 4px;
    --radius-md: 3px;
    --radius-sm: 2x;
    --color-code: #ffa810;
    --theme-font-mono: Departure Mono,monospace;
    --code-font: "Commit Mono",monospace;
    --text-shadow-color: rgba(255,152,16,.46);
    --text-shadow-color-dim: rgba(255,152,16,.25);
    --border-w: 1.5px
}

*/

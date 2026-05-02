import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class BrutalistTheme extends Theme {
  @override
  bool get isDark => true;

  @override
  IconData get icon => LucideIcons.piSquare;

  @override
  Color get foreground => Color(int.parse('#c0d0e8'.replaceAll('#', '0xFF')));

  @override
  Color get background => Color(int.parse('#080810'.replaceAll('#', '0xFF')));

  @override
  Color get border => Color(
    int.parse('#a0b4dc'.replaceAll('#', '0xFF')),
  ).withValues(alpha: 0.18);

  @override
  Color get dimmed => Color(int.parse('#99a9bf'.replaceAll('#', '0xFF')));

  @override
  TextStyle get font => TextStyle(
    fontFamily: 'ShareTechMono',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

/*

[data-theme=brutalist] {
    --font-size-base: 14px;
    --font-size-base-mobile: 16px;
    --font-size-h: 14px;
    --font-size-h-mobile: 16px;
    --font-size-p: 14px;
    --font-size-p-mobile: 14px;
    --line-height-base: 1.45;
    --letter-spacing-base: -.1px;
    --color-bg: #080810;
    --color-fg: #c0d0e8;
    --color-fg-dim: #99a9bf;
    --color-border: rgba(160,180,220,.18);
    --color-quote: rgba(160,180,220,.1);
    --color-blockquote-bg: rgba(160,180,220,.05);
    --color-code-bg: rgba(160,180,220,.06);
    --radius-lg: 1px;
    --radius-md: .8px;
    --radius-sm: .8px;
    --color-code: #c0d0e8;
    --theme-font-mono: Departure Mono,monospace;
    --code-font: "Commit Mono",monospace;
    --text-shadow-color: rgba(160,180,220,.5);
    --border-w: 1.5px
}

*/

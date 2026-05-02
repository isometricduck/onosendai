import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class Vt320Theme extends Theme {
  @override
  bool get isDark => true;

  @override
  IconData get icon => LucideIcons.monitor;

  @override
  Color get foreground => Color(int.parse('#ff9a10'.replaceAll('#', '0xFF')));

  @override
  Color get background => Color(int.parse('#170800'.replaceAll('#', '0xFF')));

  @override
  Color get border => Color(
    int.parse('#ff9b00'.replaceAll('#', '0xFF')),
  ).withValues(alpha: 0.27);

  @override
  Color get dimmed => Color(int.parse('#ff9100'.replaceAll('#', '0xFF')));

  @override
  TextStyle get font =>
      TextStyle(fontFamily: 'VT323', fontSize: 16, fontWeight: FontWeight.w400);
}

/*

[data-theme=vt320] {
    --font-size-base: 20px;
    --font-size-base-mobile: 18px;
    --font-size-h: 20px;
    --font-size-h-mobile: 18px;
    --font-size-p: 20px;
    --font-size-p-mobile: 20px;
    --line-height-base: 1.05;
    --color-bg: #170800;
    --color-fg: #ff9a10;
    --color-fg-dim: #ff9100;
    --color-border: rgba(255,155,0,.27);
    --color-quote: rgba(255,155,0,.08);
    --color-blockquote-bg: rgba(255,155,0,.05);
    --color-code-bg: rgba(255,155,0,.05);
    --radius-lg: 2.5px;
    --radius-md: 2.5px;
    --radius-sm: 2.5px;
    --color-code: #ffa920;
    --theme-font-mono: VT323,Small,monospace;
    --code-font: "JetBrains Mono","Courier New",monospace;
    --text-shadow-color: rgba(255,155,0,.5);
    --border-w: 1.5px
}

*/

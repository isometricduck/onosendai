import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';

class DarkTheme extends Theme {
  @override
  bool get isDark => true;

  @override
  IconData get icon => LucideIcons.moon;

  @override
  Color get foreground => Color(int.parse('#efe5c0'.replaceAll('#', '0xFF')));

  @override
  Color get background => Color(int.parse('#000000'.replaceAll('#', '0xFF')));

  @override
  Color get border => Color(int.parse('#3a3a3a'.replaceAll('#', '0xFF')));

  @override
  Color get dimmed => Color(int.parse('#a89984'.replaceAll('#', '0xFF')));

  @override
  TextStyle get font => TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

/*

[data-theme=dark] {
    --color-bg: #000;
    --color-fg: #efe5c0;
    --color-fg-dim: #a89984;
    --color-border: #3a3a3a;
    --color-quote: #a89984;
    --color-blockquote-bg: hsla(0,0%,100%,.07);
    --color-code-bg: hsla(0,0%,100%,.07);
    --radius-lg: 7px;
    --radius-md: 5px;
    --radius-sm: 3px;
    --color-code: #e0a044;
    --theme-font-mono: JetBrains Mono,Courier New,monospace;
    --code-font: JetBrains Mono,Courier New,monospace;
    --font-size-base: 14px;
    --font-size-base-mobile: 16px;
    --font-size-h: .875rem;
    --font-size-h-mobile: 1rem;
    --font-size-p: .875rem;
    --font-size-p-mobile: 1rem;
    --line-height-base: 1.4
}

*/

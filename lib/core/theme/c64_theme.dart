import 'dart:ui';

// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Colors;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/shader_effects.dart';
import 'package:onosendai/core/theme/theme.dart';

class C64Theme extends Theme {
  @override
  bool get isDark => true;

  @override
  IconData get icon => LucideIcons.tv;

  @override
  Color get foreground => Colors.white.withValues(alpha: 0.75);

  @override
  Color get background => Color(int.parse('#2a2ab8'.replaceAll('#', '0xFF')));

  @override
  Color get border => Colors.white.withValues(alpha: 0.3);

  @override
  Color get dimmed => Colors.white.withValues(alpha: 0.4);

  @override
  TextStyle get font => TextStyle(
    fontFamily: 'DepartureMono',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.5,
  );

  @override
  ImageShaderEffect get imageShaderEffect => const CrtEffect();
}

/*

[data-theme=c64] {
    --font-size-base: 14px;
    --font-size-base-mobile: 16px;
    --font-size-h: .875rem;
    --font-size-h-mobile: 1rem;
    --font-size-p: .875rem;
    --font-size-p-mobile: 1rem;
    --line-height-base: 1.4;
    --color-bg: #2a2ab8;
    --color-fg: hsla(0,0%,100%,.75);
    --color-fg-dim: hsla(0,0%,100%,.4);
    --color-border: hsla(0,0%,100%,.3);
    --color-quote: hsla(0,0%,100%,.6);
    --color-blockquote-bg: hsla(0,0%,100%,.08);
    --color-code-bg: hsla(0,0%,100%,.08);
    --radius-lg: 7px;
    --radius-md: 5px;
    --radius-sm: 3px;
    --color-code: #acf;
    --theme-font-mono: Slim,monospace;
    --code-font: Slim,monospace
}

*/

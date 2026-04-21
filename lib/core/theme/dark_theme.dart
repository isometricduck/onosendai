import 'dart:ui';

import 'package:onosendai/core/theme/theme.dart';

class DarkTheme extends Theme {
  @override
  Color get foreground => Color(int.parse('#efe5c0'.replaceAll('#', '0xFF')));

  @override
  Color get background => Color(int.parse('#000000'.replaceAll('#', '0xFF')));

  @override
  Color get border => Color(int.parse('#a89984'.replaceAll('#', '0xFF')));

  @override
  Color get code => Color(int.parse('#3a3a3a'.replaceAll('#', '0xFF')));

  @override
  Color get codeBg => Color(int.parse('#e0a044'.replaceAll('#', '0xFF')));

  @override
  Color get dimmed => Color(int.parse('#a89984'.replaceAll('#', '0xFF')));
}

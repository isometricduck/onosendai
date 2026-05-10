import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';

const fontScalePrefsKey = 'font_scale';

final initialFontScaleProvider = Provider<double?>((ref) => null);

final fontScaleProvider = NotifierProvider<FontScaleNotifier, double>(
  FontScaleNotifier.new,
);

class FontScaleNotifier extends Notifier<double> {
  @override
  double build() {
    final initialValue = ref.watch(initialFontScaleProvider);
    if (initialValue != null) return initialValue;

    unawaited(_load());
    return 1.0;
  }

  Future<void> _load() async {
    final scale = await ref.read(appPrefsProvider).getDouble(fontScalePrefsKey);
    if (scale != null) state = scale;
  }

  Future<void> setScale(double scale) async {
    state = scale;
    await ref.read(appPrefsProvider).setDouble(fontScalePrefsKey, scale);
  }
}

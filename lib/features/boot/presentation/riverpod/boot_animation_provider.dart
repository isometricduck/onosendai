import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/prefs_provider.dart';

const bootAnimationEnabledPrefsKey = 'boot_animation_enabled';

final initialBootAnimationEnabledProvider = Provider<bool?>((ref) => null);

final bootAnimationEnabledProvider =
    NotifierProvider<BootAnimationEnabledNotifier, bool>(
      BootAnimationEnabledNotifier.new,
    );

class BootAnimationEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    final initialValue = ref.watch(initialBootAnimationEnabledProvider);
    if (initialValue != null) return initialValue;

    unawaited(_load());
    return true;
  }

  Future<void> _load() async {
    final enabled = await ref
        .read(appPrefsProvider)
        .getBool(bootAnimationEnabledPrefsKey);
    if (enabled != null) state = enabled;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await ref
        .read(appPrefsProvider)
        .setBool(bootAnimationEnabledPrefsKey, enabled);
  }
}

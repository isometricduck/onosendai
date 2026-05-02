import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/prefs/app_prefs.dart';
import 'package:onosendai/core/prefs/current_user_prefs.dart';
import 'package:onosendai/core/prefs/shared_preferences_app_prefs.dart';

final appPrefsProvider = Provider<AppPrefs>((ref) {
  return SharedPreferencesAppPrefs();
});

final currentUserPrefsProvider = Provider<CurrentUserPrefs>((ref) {
  return CurrentUserPrefs(ref.read(appPrefsProvider));
});

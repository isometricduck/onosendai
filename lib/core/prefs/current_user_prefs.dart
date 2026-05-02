import 'dart:convert';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:onosendai/core/prefs/app_prefs.dart';

const currentUserProfilePrefsKey = 'current_user_profile';

class CurrentUserPrefs {
  final AppPrefs _prefs;

  const CurrentUserPrefs(this._prefs);

  Future<void> setProfile(UserProfile profile) {
    return _prefs.setString(
      currentUserProfilePrefsKey,
      jsonEncode(_profileToJson(profile)),
    );
  }

  Future<UserProfile?> getProfile() async {
    final value = await _prefs.getString(currentUserProfilePrefsKey);
    if (value == null) return null;

    final decoded = jsonDecode(value) as Map<String, dynamic>;
    return UserProfile.fromJson(decoded);
  }

  Future<void> clear() => _prefs.remove(currentUserProfilePrefsKey);
}

Map<String, dynamic> _profileToJson(UserProfile profile) {
  return {
    'userId': profile.userId,
    'username': profile.username,
    'displayName': profile.displayName,
    'bio': profile.bio,
    'pinnedPostId': profile.pinnedPostId,
    'websiteUrl': profile.websiteUrl,
    'websiteName': profile.websiteName,
    'websiteImageUrl': profile.websiteImageUrl,
    'locationLatitude': profile.locationLatitude,
    'locationLongitude': profile.locationLongitude,
    'locationName': profile.locationName,
    'createdAt': profile.createdAt?.toIso8601String(),
  };
}

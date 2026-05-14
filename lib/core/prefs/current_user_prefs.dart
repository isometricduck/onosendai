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
    'createdAt': profile.createdAt?.toIso8601String(),
    'serialNumber': profile.serialNumber,
    'guildIcon': profile.guildIcon,
    'guildSlug': profile.guildSlug,
    'guildId': profile.guildId,
    'isSupporter': profile.isSupporter,
    'supporterIcon': profile.supporterIcon,
    'locationName': profile.locationName,
    'followingCount': profile.followingCount,
    'guildName': profile.guildName,
    'hasPublicPosts': profile.hasPublicPosts,
    'profilePictureUrl': profile.profilePictureUrl,
    'updatedAt': profile.updatedAt?.toIso8601String(),
    'bio': profile.bio,
    'websiteName': profile.websiteName,
    'websiteUrl': profile.websiteUrl,
    'postsCount': profile.postsCount,
    'publicPostsCount': profile.publicPostsCount,
    'pinnedPostId': profile.pinnedPostId,
    'followersCount': profile.followersCount,
    'lastActiveAt': profile.lastActiveAt?.toIso8601String(),
  };
}

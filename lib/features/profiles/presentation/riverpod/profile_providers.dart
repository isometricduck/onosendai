import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';

final currentUserProfileProvider = FutureProvider<UserProfile>((ref) {
  return ref.read(cyberspaceClientProvider).users.getMe();
});

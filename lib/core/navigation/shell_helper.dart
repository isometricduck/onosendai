import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/navigation_state.dart';
import 'package:onosendai/core/providers/nav_provider.dart';
import 'package:onosendai/features/notifications/presentation/riverpod/notifications_providers.dart';

NavState getNavigationState(WidgetRef ref) {
  return (ref.read(navNotifierProvider));
}

int getUnreadNotifications(WidgetRef ref) {
  return (ref.read(notificationsNotifierProvider).valueOrNull?.unreadCount ??
      0);
}

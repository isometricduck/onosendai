import 'package:cyberspace_client/cyberspace_client.dart';

class NotificationsState {
  final List<Notification> notifications;
  final String? nextCursor;
  final bool isLoadingMore;

  const NotificationsState({
    required this.notifications,
    required this.nextCursor,
    this.isLoadingMore = false,
  });

  bool get hasMore => nextCursor != null;

  int get unreadCount => notifications.where((notification) {
    return !notification.read;
  }).length;

  NotificationsState copyWith({
    List<Notification>? notifications,
    String? nextCursor,
    bool clearCursor = false,
    bool? isLoadingMore,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      nextCursor: clearCursor ? null : nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

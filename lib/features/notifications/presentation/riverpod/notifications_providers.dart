import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:onosendai/features/notifications/domain/entities/notifications_state.dart';
import 'package:onosendai/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:onosendai/features/notifications/domain/usecases/fetch_notifications_usecase.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepositoryImpl(ref.read(cyberspaceClientProvider));
});

final fetchNotificationsUseCaseProvider = Provider<FetchNotificationsUseCase>((
  ref,
) {
  return FetchNotificationsUseCase(ref.read(notificationsRepositoryProvider));
});

final notificationsNotifierProvider =
    AsyncNotifierProvider<NotificationsNotifier, NotificationsState>(
      NotificationsNotifier.new,
    );

class NotificationsNotifier extends AsyncNotifier<NotificationsState> {
  @override
  Future<NotificationsState> build() async {
    final page = await ref.read(fetchNotificationsUseCaseProvider)();
    return NotificationsState(
      notifications: page.data,
      nextCursor: page.cursor,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final page = await ref
          .read(fetchNotificationsUseCaseProvider)
          .call(cursor: current.nextCursor);
      state = AsyncData(
        current.copyWith(
          notifications: [...current.notifications, ...page.data],
          nextCursor: page.cursor,
          clearCursor: page.cursor == null,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
      rethrow;
    }
  }
}

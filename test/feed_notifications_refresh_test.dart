import 'package:cyberspace_client/cyberspace_client.dart' as cyberspace;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/features/feed/domain/repositories/feed_repository.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:onosendai/features/notifications/presentation/riverpod/notifications_providers.dart';

class _CountingFeedRepository implements FeedRepository {
  int fetchCalls = 0;

  @override
  Future<List<cyberspace.Post>> fetchCached({int limit = 20}) async => const [];

  @override
  Future<cyberspace.PagedResult<cyberspace.Post>> fetch({
    int limit = 20,
    String? cursor,
  }) async {
    fetchCalls += 1;
    return const cyberspace.PagedResult(data: [], cursor: null);
  }

  @override
  Future<List<cyberspace.Reply>> fetchCachedReplies(
    String postId, {
    int limit = 20,
  }) async => const [];

  @override
  Future<cyberspace.PagedResult<cyberspace.Reply>> fetchReplies(
    String postId, {
    int limit = 20,
    String? cursor,
  }) async {
    return const cyberspace.PagedResult(data: [], cursor: null);
  }

  @override
  Future<void> deletePost(String postId) async {}

  @override
  Future<void> deleteReply(String replyId) async {}
}

class _CountingNotificationsRepository implements NotificationsRepository {
  int fetchCalls = 0;

  @override
  Future<cyberspace.PagedResult<cyberspace.Notification>> fetch({
    int limit = 20,
    String? cursor,
  }) async {
    fetchCalls += 1;
    return const cyberspace.PagedResult(data: [], cursor: null);
  }
}

void main() {
  test('feed initial load and refresh also fetch notifications', () async {
    final feedRepository = _CountingFeedRepository();
    final notificationsRepository = _CountingNotificationsRepository();
    final container = ProviderContainer(
      overrides: [
        feedRepositoryProvider.overrideWithValue(feedRepository),
        notificationsRepositoryProvider.overrideWithValue(
          notificationsRepository,
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(feedNotifierProvider.future);
    await Future<void>.delayed(Duration.zero);

    expect(feedRepository.fetchCalls, 1);
    expect(notificationsRepository.fetchCalls, 1);

    await container.read(feedNotifierProvider.notifier).refresh();

    expect(feedRepository.fetchCalls, 2);
    expect(notificationsRepository.fetchCalls, 2);
  });
}

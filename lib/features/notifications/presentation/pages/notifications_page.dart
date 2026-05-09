import 'dart:async';

import 'package:cyberspace_client/cyberspace_client.dart' as cyberspace;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/feed/presentation/pages/post_detail_page.dart';
import 'package:onosendai/features/notifications/domain/entities/notifications_state.dart';
import 'package:onosendai/features/notifications/presentation/riverpod/notifications_providers.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final _scrollController = ScrollController();
  static const _loadMoreThreshold = 400.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      ref.read(notificationsNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final notificationsAsync = ref.watch(notificationsNotifierProvider);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final body = ColoredBox(
      color: theme.pageBackground,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: notificationsAsync.when(
              loading: () => const _CenteredSpinner(),
              error: (err, _) => _ErrorView(
                message: _errorMessage(err),
                onRetry: () =>
                    ref.read(notificationsNotifierProvider.notifier).refresh(),
              ),
              data: (state) => _NotificationsList(
                state: state,
                scrollController: _scrollController,
                showInlineHeader: !isMobile,
                onRefresh: () =>
                    ref.read(notificationsNotifierProvider.notifier).refresh(),
              ),
            ),
          ),
        ),
      ),
    );

    if (!isMobile) {
      return Scaffold(backgroundColor: theme.pageBackground, body: body);
    }

    return Scaffold(
      backgroundColor: theme.pageBackground,
      appBar: AppBar(
        backgroundColor: theme.pageBackground,
        foregroundColor: theme.headingText,
        surfaceTintColor: theme.pageBackground,
        title: Text(
          'NOTIFICATIONS',
          style: theme.mainFont.copyWith(
            color: theme.headingText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: body,
    );
  }
}

String _errorMessage(Object err) {
  debugPrint('Notifications load error: $err');
  if (err is cyberspace.CyberspaceApiException) return err.message;
  return 'Something went wrong.';
}

class _NotificationsList extends StatelessWidget {
  final NotificationsState state;
  final ScrollController scrollController;
  final bool showInlineHeader;
  final Future<void> Function() onRefresh;

  const _NotificationsList({
    required this.state,
    required this.scrollController,
    required this.showInlineHeader,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (state.notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            if (showInlineHeader) const _InlineHeader(unreadCount: 0),
            const SizedBox(height: 120),
            const Center(child: _DimmedText('No notifications yet.')),
          ],
        ),
      );
    }

    final itemCount =
        state.notifications.length + 1 + (showInlineHeader ? 1 : 0);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          var cursor = 0;

          if (showInlineHeader) {
            if (index == cursor) {
              return _InlineHeader(unreadCount: state.unreadCount);
            }
            cursor += 1;
          }

          final notificationIndex = index - cursor;
          if (notificationIndex < state.notifications.length) {
            return _NotificationCard(
              notification: state.notifications[notificationIndex],
            );
          }

          if (state.isLoadingMore) return const _InlineSpinner();
          if (state.hasMore) return const SizedBox.shrink();
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: _DimmedText('-- end of notifications --')),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends ConsumerStatefulWidget {
  final cyberspace.Notification notification;

  const _NotificationCard({required this.notification});

  @override
  ConsumerState<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends ConsumerState<_NotificationCard> {
  var _opening = false;

  Future<void> _openTarget() async {
    if (_opening) return;

    final notification = widget.notification;
    final postId = notification.targetId;
    if (postId == null) return;

    setState(() => _opening = true);
    try {
      final client = ref.read(cyberspaceClientProvider);
      if (!notification.read) {
        unawaited(
          client.notifications.markRead(notification.notificationId).catchError(
            (Object error, StackTrace stackTrace) {
              debugPrint('Could not mark notification read: $error');
            },
          ),
        );
      }

      final post = await client.posts.get(postId);
      if (!mounted) return;

      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => PostDetailPage(post: post)));
    } catch (error) {
      if (!mounted) return;
      final theme = context.theme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorMessage(error),
            style: theme.mainFont.copyWith(color: theme.snackbarText),
          ),
          backgroundColor: theme.snackbarBackground,
        ),
      );
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final notification = widget.notification;
    final title = _titleFor(notification);
    final details = _detailsFor(notification);
    final createdAt = notification.createdAt;
    final canOpen = notification.targetId != null;

    return Material(
      color: theme.cardBackground,
      child: InkWell(
        onTap: canOpen ? _openTarget : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: notification.read ? theme.notificationReadBorder : theme.notificationUnreadBorder,
            ),
            color: theme.cardBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_opening)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: theme.actionIcon,
                    ),
                  )
                else
                  Icon(
                    notification.read ? LucideIcons.bell : LucideIcons.bellRing,
                    color: notification.read ? theme.notificationReadIcon : theme.notificationUnreadIcon,
                    size: 20,
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.mainFont.copyWith(
                          color: theme.headingText,
                          fontWeight: notification.read
                              ? FontWeight.w400
                              : FontWeight.w700,
                        ),
                      ),
                      if (details != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          details,
                          style: theme.mainFont.copyWith(color: theme.metaText),
                        ),
                      ],
                      if (createdAt != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _formatTimestamp(createdAt),
                          style: theme.mainFont.copyWith(
                            color: theme.metaText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _titleFor(cyberspace.Notification notification) {
  final actorUsername = notification.actorUsername ?? 'Someone';

  return switch (notification.type) {
    cyberspace.NotificationType.reply => '$actorUsername replied to you',
    cyberspace.NotificationType.bookmark => '$actorUsername saved your entry',
    cyberspace.NotificationType.newPostFollowing =>
      '$actorUsername published something',
    cyberspace.NotificationType.poke => '$actorUsername poked you',
    cyberspace.NotificationType.guildNewThread =>
      '$actorUsername posted a new thread',
    cyberspace.NotificationType.replyMention =>
      '$actorUsername mentioned you in a reply',
    cyberspace.NotificationType.supporterGranted =>
      '$actorUsername upgraded you to a supporter account',
    cyberspace.NotificationType.threadReply =>
      '$actorUsername replied in a watched thread',
    cyberspace.NotificationType.unknown =>
      'Notification: ${notification.rawType}',
  };
}

String? _detailsFor(cyberspace.Notification notification) {
  final entries = notification.data.entries
      .where((entry) => entry.value != null)
      .map((entry) => '${entry.key}: ${entry.value}')
      .toList();
  if (entries.isEmpty) return null;
  return entries.join('\n');
}

String _formatTimestamp(DateTime timestamp) {
  final local = timestamp.toLocal();
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  final date =
      '${local.year}-${twoDigits(local.month)}-${twoDigits(local.day)}';
  final time = '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  return '$date $time';
}

class _InlineHeader extends StatelessWidget {
  final int unreadCount;

  const _InlineHeader({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Icon(LucideIcons.bell, color: theme.headingText),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Notifications',
            style: theme.mainFont.copyWith(
              color: theme.headingText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '$unreadCount unread',
          style: theme.mainFont.copyWith(color: theme.metaText, fontSize: 12),
        ),
      ],
    );
  }
}

class _CenteredSpinner extends StatelessWidget {
  const _CenteredSpinner();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: context.theme.actionIcon,
        ),
      ),
    );
  }
}

class _InlineSpinner extends StatelessWidget {
  const _InlineSpinner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: context.theme.actionIcon,
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('[ERROR]', style: theme.mainFont),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: theme.mainFont),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: theme.primaryButtonForeground,
                textStyle: theme.mainFont,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DimmedText extends StatelessWidget {
  final String text;

  const _DimmedText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.theme.mainFont.copyWith(color: context.theme.metaText),
    );
  }
}

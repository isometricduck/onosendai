import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/theme/theme.dart';
import 'package:onosendai/features/feed/presentation/pages/post_detail_page.dart';
import 'package:onosendai/features/feed/presentation/riverpod/feed_providers.dart';
import 'package:onosendai/features/feed/presentation/widgets/eink_post_card.dart';

typedef EinkDestinationSheetBuilder =
    Widget Function(BuildContext context, VoidCallback hideOverlay);

class EinkFeedPage extends ConsumerStatefulWidget {
  final EinkDestinationSheetBuilder? destinationSheetBuilder;

  const EinkFeedPage({super.key, this.destinationSheetBuilder});

  @override
  ConsumerState<EinkFeedPage> createState() => _EinkFeedPageState();
}

class _EinkFeedPageState extends ConsumerState<EinkFeedPage> {
  var _selectedIndex = 0;
  var _overlayVisible = false;

  void _previousPost() {
    if (_selectedIndex <= 0) return;
    setState(() {
      _selectedIndex -= 1;
      _overlayVisible = false;
    });
  }

  Future<void> _nextPost() async {
    final state = ref.read(feedNotifierProvider).valueOrNull;
    if (state == null || state.posts.isEmpty) return;

    final nextIndex = _selectedIndex + 1;
    if (nextIndex < state.posts.length) {
      setState(() {
        _selectedIndex = nextIndex;
        _overlayVisible = false;
      });
      return;
    }

    if (!state.hasMore || state.isLoadingMore) return;

    try {
      await ref.read(feedNotifierProvider.notifier).loadMore();
      final updatedState = ref.read(feedNotifierProvider).valueOrNull;
      if (!mounted || updatedState == null) return;
      if (nextIndex < updatedState.posts.length) {
        setState(() {
          _selectedIndex = nextIndex;
          _overlayVisible = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not load more.')));
    }
  }

  void _toggleOverlay() {
    setState(() => _overlayVisible = !_overlayVisible);
  }

  void _hideOverlay() {
    if (!_overlayVisible) return;
    setState(() => _overlayVisible = false);
  }

  void _savePost(Post post) {
    setState(() => _overlayVisible = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Save action coming soon.')));
  }

  void _replyToPost(Post post) {
    setState(() => _overlayVisible = false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostDetailPage(post: post, initiallyReplying: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final feedAsync = ref.watch(feedNotifierProvider);

    return ColoredBox(
      color: theme.background,
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) {
            final width = MediaQuery.sizeOf(context).width;
            final x = details.localPosition.dx;

            if (x <= width * 0.3) {
              _previousPost();
              return;
            }

            if (x < width / 2) {
              _toggleOverlay();
              return;
            }

            if (x >= width / 2) _nextPost();
          },
          child: Stack(
            children: [
              feedAsync.when(
                loading: () => const _CenteredStatus('Loading...'),
                error: (error, _) => _EinkFeedErrorView(
                  message: _errorMessage(error),
                  onRetry: () =>
                      ref.read(feedNotifierProvider.notifier).refresh(),
                ),
                data: (state) {
                  if (state.posts.isEmpty) {
                    return const _CenteredStatus('No posts yet.');
                  }

                  final selectedIndex = _selectedIndex.clamp(
                    0,
                    state.posts.length - 1,
                  );

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                EinkPostCard(
                                  post: state.posts[selectedIndex],
                                  full: true,
                                ),
                                Positioned.fill(
                                  child: IgnorePointer(
                                    ignoring: !_overlayVisible,
                                    child: AnimatedOpacity(
                                      opacity: _overlayVisible ? 1.0 : 0.0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: _ActionsOverlay(
                                        onSave: () => _savePost(
                                          state.posts[selectedIndex],
                                        ),
                                        onReply: () => _replyToPost(
                                          state.posts[selectedIndex],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (state.isLoadingMore) ...[
                              const SizedBox(height: 16),
                              const _CenteredStatus('Loading more...'),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (widget.destinationSheetBuilder case final builder?)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    ignoring: !_overlayVisible,
                    child: AnimatedOpacity(
                      opacity: _overlayVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: builder(context, _hideOverlay),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsOverlay extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onReply;

  const _ActionsOverlay({required this.onSave, required this.onReply});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background.withValues(alpha: 0.88),
        border: Border.all(color: theme.border, width: 1),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OverlayAction(
              icon: LucideIcons.bookmark,
              label: 'Save',
              onTap: onSave,
            ),
            const SizedBox(width: 20),
            _OverlayAction(
              icon: LucideIcons.messageSquare,
              label: 'Reply',
              onTap: onReply,
            ),
          ],
        ),
      ),
    );
  }
}

class _OverlayAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OverlayAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Tooltip(
      message: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: 72,
          height: 72,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.background,
              border: Border.all(color: theme.foreground, width: 1),
            ),
            child: Icon(icon, color: theme.foreground, size: 32),
          ),
        ),
      ),
    );
  }
}

String _errorMessage(Object error) {
  debugPrint('E Ink feed load error: $error (${error.runtimeType})');
  if (error is CyberspaceApiException) return error.message;
  return 'Something went wrong.';
}

class _CenteredStatus extends StatelessWidget {
  final String message;

  const _CenteredStatus(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: context.theme.mainFont));
  }
}

class _EinkFeedErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _EinkFeedErrorView({required this.message, required this.onRetry});

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
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

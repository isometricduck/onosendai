import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/widgets/error_snackbar.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';
import 'package:onosendai/features/journal/domain/entities/journal_state.dart';
import 'package:onosendai/features/journal/presentation/riverpod/journal_providers.dart';
import 'package:onosendai/features/journal/presentation/widgets/note_card.dart';

class JournalPage extends ConsumerStatefulWidget {
  const JournalPage({super.key});

  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage> {
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
      ref.read(journalNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final journalAsync = ref.watch(journalNotifierProvider);
    ref.listen(journalNotifierProvider, (_, next) {
      if (!next.hasError || next.isLoading) return;
      showErrorSnackBar(context, _errorMessage(next.error!));
    });

    return ColoredBox(
      color: theme.pageBackground,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: journalAsync.when(
              skipError: true,
              loading: () => const _CenteredSpinner(),
              error: (_, _) => const SizedBox.shrink(),
              data: (state) => _JournalList(
                state: state,
                scrollController: _scrollController,
                onRefresh: () =>
                    ref.read(journalNotifierProvider.notifier).refresh(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _errorMessage(Object err) {
  debugPrint('Journal load error: $err');
  if (err is CyberspaceApiException) return err.message;
  return 'Something went wrong.';
}

class _JournalList extends ConsumerWidget {
  final JournalState state;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  const _JournalList({
    required this.state,
    required this.scrollController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.notes.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: _DimmedText('No notes yet.')),
          ],
        ),
      );
    }

    final itemCount = state.notes.length + 1;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index < state.notes.length) {
            final note = state.notes[index];
            return NoteCard(
              note: note,
              onDelete: () async {
                final confirmed = await _confirmDeleteNote(context);
                if (!confirmed) return;
                ref
                    .read(journalNotifierProvider.notifier)
                    .deleteNote(note.noteId);
              },
            );
          }
          if (state.isLoadingMore) return const _InlineSpinner();
          if (state.hasMore) return const SizedBox.shrink();
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: _DimmedText('-- end of journal --')),
          );
        },
      ),
    );
  }
}

Future<bool> _confirmDeleteNote(BuildContext context) async {
  final theme = context.cyberTheme;
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme.dialogBackground,
          surfaceTintColor: theme.dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: theme.dialogBorder),
          ),
          title: Text(
            'Delete note?',
            style: theme.mainFont.copyWith(
              color: theme.headingText,
              fontSize: 18,
            ),
          ),
          content: Text(
            'This note will be removed from your journal.',
            style: theme.mainFont.copyWith(color: theme.metaText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: theme.secondaryButtonBorder,
                textStyle: theme.mainFont,
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: theme.primaryButtonBackground,
                foregroundColor: theme.primaryButtonForeground,
                textStyle: theme.mainFont,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;
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
          color: context.cyberTheme.actionIcon,
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
            color: context.cyberTheme.actionIcon,
          ),
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
    return Text(text, style: context.cyberTheme.mainFont);
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/providers/client_provider.dart';
import 'package:onosendai/features/journal/data/repositories/journal_repository_impl.dart';
import 'package:onosendai/features/journal/domain/entities/journal_state.dart';
import 'package:onosendai/features/journal/domain/repositories/journal_repository.dart';
import 'package:onosendai/features/journal/domain/usecases/delete_journal_note_usecase.dart';
import 'package:onosendai/features/journal/domain/usecases/fetch_journal_usecase.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepositoryImpl(ref.read(cyberspaceClientProvider));
});

final fetchJournalUseCaseProvider = Provider<FetchJournalUseCase>((ref) {
  return FetchJournalUseCase(ref.read(journalRepositoryProvider));
});

final deleteJournalNoteUseCaseProvider = Provider<DeleteJournalNoteUseCase>((
  ref,
) {
  return DeleteJournalNoteUseCase(ref.read(journalRepositoryProvider));
});

final journalNotifierProvider =
    AsyncNotifierProvider<JournalNotifier, JournalState>(JournalNotifier.new);

class JournalNotifier extends AsyncNotifier<JournalState> {
  @override
  Future<JournalState> build() async {
    try {
      debugPrint('Building JournalNotifier');
      final page = await ref.read(fetchJournalUseCaseProvider)();
      debugPrint('Page: $page');
      return JournalState(notes: page.data, nextCursor: page.cursor);
    } catch (e, st) {
      debugPrint('Error in JournalNotifier: $e\n$st');
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final page = await ref.read(fetchJournalUseCaseProvider)();
      return JournalState(notes: page.data, nextCursor: page.cursor);
    });
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(fetchJournalUseCaseProvider)
          .call(cursor: current.nextCursor);
      state = AsyncData(
        current.copyWith(
          notes: [...current.notes, ...page.data],
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

  Future<void> deleteNote(String noteId) async {
    final current = state.valueOrNull;
    await ref.read(deleteJournalNoteUseCaseProvider)(noteId);
    if (current == null) {
      ref.invalidateSelf();
      return;
    }
    state = AsyncData(
      current.copyWith(
        notes: current.notes
            .where((note) => note.noteId != noteId)
            .toList(growable: false),
      ),
    );
  }
}

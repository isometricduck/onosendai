import 'package:cyberspace_client/cyberspace_client.dart';

class JournalState {
  final List<Note> notes;
  final String? nextCursor;
  final bool isLoadingMore;

  const JournalState({
    required this.notes,
    this.nextCursor,
    this.isLoadingMore = false,
  });

  bool get hasMore => nextCursor != null;

  JournalState copyWith({
    List<Note>? notes,
    String? nextCursor,
    bool clearCursor = false,
    bool? isLoadingMore,
  }) {
    return JournalState(
      notes: notes ?? this.notes,
      nextCursor: clearCursor ? null : nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

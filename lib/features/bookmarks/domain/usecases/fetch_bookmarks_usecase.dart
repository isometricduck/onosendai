import 'package:onosendai/features/bookmarks/domain/entities/bookmarks_state.dart';
import 'package:onosendai/features/bookmarks/domain/repositories/bookmarks_repository.dart';

class FetchBookmarksUseCase {
  final BookmarksRepository _repo;

  FetchBookmarksUseCase(this._repo);

  Future<BookmarksState> cached() => _repo.fetchCached();

  Future<BookmarksState> call() => _repo.fetch();
}

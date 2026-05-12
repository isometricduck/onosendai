import 'package:onosendai/features/bookmarks/domain/entities/bookmarks_state.dart';

abstract class BookmarksRepository {
  Future<BookmarksState> fetchCached();
  Future<BookmarksState> fetch();
}

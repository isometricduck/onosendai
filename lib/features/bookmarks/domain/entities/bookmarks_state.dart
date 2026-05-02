import 'package:cyberspace_client/cyberspace_client.dart';

class BookmarksState {
  final List<Post> posts;
  final List<Reply> replies;

  const BookmarksState({required this.posts, required this.replies});

  bool get isEmpty => posts.isEmpty && replies.isEmpty;
}

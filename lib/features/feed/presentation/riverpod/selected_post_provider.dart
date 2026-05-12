import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedPostProvider =
    StateProvider<(Post post, bool initiallyReplying)?>((_) => null);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/core/navigation/navigation_state.dart';

class NavigationNotifier extends Notifier<NavState> {
  @override
  NavState build() => NavState(destination: AppDestination.feed, pendingEffect: null);
}

final navNotifierProvider =
    NotifierProvider<NavigationNotifier, NavState>(
      NavigationNotifier.new,
    );
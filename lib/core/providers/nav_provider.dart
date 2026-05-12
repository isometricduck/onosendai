import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/core/navigation/navigation_state.dart';
import 'package:onosendai/core/navigation/shell_effect.dart';

class NavigationNotifier extends Notifier<NavState> {
  @override
  NavState build() => NavState(destination: AppDestination.feed, pendingEffect: null);

  void goTo(AppDestination destination) {
    state = state.copyWith(
      destination: destination,
      clearPendingEffect: true,
    );
  }

  void showEffect(ShellEffect effect) {
    state = state.copyWith(pendingEffect: effect);
  }

  void clearEffect() {
    state = state.copyWith(clearPendingEffect: true);
  }
}

final navNotifierProvider =
    NotifierProvider<NavigationNotifier, NavState>(
      NavigationNotifier.new,
    );
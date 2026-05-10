import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onosendai/core/navigation/destinations.dart';

class NavigationNotifier extends Notifier<AppDestination> {
  @override
  Destination build() => Destination.home;

  void goTo(Destination destination) {
    // guard, analytics, side effects, etc.
    state = destination;
  }

  void goBack() { ... }
}
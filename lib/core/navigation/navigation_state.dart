import 'package:onosendai/core/navigation/destinations.dart';
import 'package:onosendai/core/navigation/shell_effect.dart';

class NavState {
  final AppDestination destination;
  final ShellEffect? pendingEffect;

  const NavState({required this.destination, this.pendingEffect});

  NavState copyWith({
    AppDestination? destination,
    ShellEffect? pendingEffect,
    bool clearPendingEffect = false,
  }) {
    return NavState(
      destination: destination ?? this.destination,
      pendingEffect: clearPendingEffect
          ? null
          : pendingEffect ?? this.pendingEffect,
    );
  }
}

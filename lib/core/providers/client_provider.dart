import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokensProvider = StateProvider<AuthTokens?>((ref) => null);

class _RiverpodAuthTokenProvider implements AuthTokenProvider {
  final Ref _ref;
  _RiverpodAuthTokenProvider(this._ref);

  @override
  Future<String?> getToken() async => _ref.read(authTokensProvider)?.idToken;

  @override
  Future<void> onUnauthorized() async {
    _ref.read(authTokensProvider.notifier).state = null;
  }
}

final cyberspaceClientProvider = Provider<CyberspaceClient>((ref) {
  return CyberspaceClient(authTokenProvider: _RiverpodAuthTokenProvider(ref));
});

import 'dart:io';

import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/foundation.dart';
import 'package:onosendai/core/auth/token_storage.dart';

class FileTokenStorage implements TokenStorage {
  final File _file;

  FileTokenStorage([File? file]) : _file = file ?? _defaultFile();

  static File _defaultFile() {
    final env = Platform.environment;
    final configHome = env['XDG_CONFIG_HOME'] ?? '${env['HOME']}/.config';
    debugPrint("Default file is $configHome/onosendai/config.json");
    return File('$configHome/onosendai/config.json');
  }

  @override
  Future<AuthTokens?> read() async {
    if (!await _file.exists()) return null;
    final raw = await _file.readAsString();
    if (raw.isEmpty) return null;
    return decodeAuthTokens(raw);
  }

  @override
  Future<void> write(AuthTokens tokens) async {
    await _file.parent.create(recursive: true);
    await _file.writeAsString(encodeAuthTokens(tokens), flush: true);
    await Process.run('chmod', ['600', _file.path]);
  }

  @override
  Future<void> clear() async {
    if (await _file.exists()) await _file.delete();
  }
}

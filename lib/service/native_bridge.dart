import 'package:flutter/services.dart';

/// Ponte de comunicacao com APIs nativas do Android/iOS.
///
/// Encapsula o MethodChannel para obter nivel de bateria.
class NativeBridge {
  static const _channel = MethodChannel('com.fittracker.app/battery');

  /// Obtem o nivel de bateria do dispositivo (0-100).
  /// Lanca [PlatformException] se indisponivel no nativo.
  /// Lanca [MissingPluginException] se nao implementado.
  static Future<int> getBatteryLevel() async {
    final int? level = await _channel.invokeMethod<int>('getBatteryLevel');
    return level ?? -1;
  }

  /// Versao segura de [getBatteryLevel]. Retorna -1 em caso de erro.
  static Future<int> getBatteryLevelSafe() async {
    try {
      return await getBatteryLevel();
    } catch (_) {
      return -1;
    }
  }
}

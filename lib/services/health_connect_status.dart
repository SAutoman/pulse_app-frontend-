import 'package:flutter/services.dart';

class HealthConnectStatus {
  static const MethodChannel _channel = MethodChannel('com.tmateapp.tmateapp/health_connect');

  static Future<bool> checkHealthConnectStatus() async {
    try {
      final bool isConnected = await _channel.invokeMethod('checkHealthConnectStatus');
      return isConnected;
    } on PlatformException catch (e) {
      print("Failed to check Health Connect status: ${e.message}");
      return false;
    }
  }
}
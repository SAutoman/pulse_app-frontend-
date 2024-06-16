import 'package:package_info_plus/package_info_plus.dart';
import 'package:pulse_mate_app/database/api_calls.dart';

class AppSettingsProvider {
  // Check for maintenance mode and app version updates
  Future<Map<String, dynamic>> checkAppStatus() async {
    Map<String, String> settings = await ApiDatabase().getAppSettings();
    bool isMaintenanceMode = settings['maintenance_mode'] == 'true';

    // Get the installed version of the app
    final packageInfo = await PackageInfo.fromPlatform();
    String installedVersion = packageInfo.version;
    String latestVersion = settings['latest_app_version'] ?? '';

    bool isUpdateAvailable = isVersionOlder(installedVersion, latestVersion);

    print({
      'isMaintenanceMode': isMaintenanceMode,
      'isUpdateAvailable': isUpdateAvailable,
      'latestVersion': latestVersion
    });

    return {
      'isMaintenanceMode': isMaintenanceMode,
      'isUpdateAvailable': isUpdateAvailable,
      'latestVersion': latestVersion
    };
  }

  // Compare versions to check if the installed version is older
  bool isVersionOlder(String installedVersion, String latestVersion) {
    List<int> installed = installedVersion.split('.').map(int.parse).toList();
    List<int> latest = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < latest.length; i++) {
      if (installed[i] < latest[i]) return true;
      if (installed[i] > latest[i]) return false;
    }
    return false;
  }
}

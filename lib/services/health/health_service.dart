import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health/health.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthService {
  final Health health = Health();

  bool _isRequestingPermissions = false;

  Future<bool> requestPermissions() async {
    if (_isRequestingPermissions) {
      print("A permissions request is already in progress.");
      return false;
    }

    _isRequestingPermissions = true;
    final healthDataTypes = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.WORKOUT,
    ];

    final permissionMap = {
      HealthDataType.STEPS: Permission.activityRecognition,
      HealthDataType.HEART_RATE: Permission.sensors,
      HealthDataType.WORKOUT: Permission.sensors,
    };

    if (Platform.isAndroid) {
      print('@@@@@ Requesting Health Permissions Android @@@@@');
      final permissions =
          healthDataTypes.map((dataType) => permissionMap[dataType]!).toList();

      // Request permissions using PermissionHandler on Android
      final statuses = await Future.wait(
          permissions.map((permission) => permission.request()));

      // Handle permanently denied cases and re-check on Android 13+
      for (var i = 0; i < statuses.length; i++) {
        final status = statuses[i];
        final dataType = healthDataTypes[i];
        print('${dataType}: ${status} ${status.isGranted}');

        if (status.isPermanentlyDenied) {
          await openAppSettings();
        } else if (!status.isGranted && !status.isDenied) {
          // Handle undetermined status (applicable to all versions)
          if (Platform.isAndroid &&
              defaultTargetPlatform == TargetPlatform.android &&
              int.parse(Platform.version.split(".")[0]) >= 13) {
            // Consider re-requesting permission on Android 13+
            final newStatus = await permissions[i].request();
            print('${dataType} re-check: ${newStatus} ${newStatus.isGranted}');
          }
        }
      }

      // Check if all permissions are granted (excluding permanently denied)
      final granted = statuses
          .where((status) => !status.isPermanentlyDenied)
          .every((status) => status.isGranted);

      _isRequestingPermissions = false;
      print('Final health permissions: $granted');
      await getHealthConnectSdkStatus();
      return granted;
    } else if (Platform.isIOS) {
      final permissions =
          healthDataTypes.map((e) => HealthDataAccess.READ).toList();

      // First, check if the permissions are already granted
      final hasPermissionsResult = await health.hasPermissions(
        healthDataTypes,
        permissions: permissions,
      );

      // If result is null (undetermined on iOS), or false (not granted), request permissions
      if (hasPermissionsResult == null || hasPermissionsResult == false) {
        try {
          final requestResult = await health.requestAuthorization(
            healthDataTypes,
            permissions: permissions,
          );
          _isRequestingPermissions = false;
          return requestResult;
        } catch (e) {
          print('Error requesting permissions: $e');
          _isRequestingPermissions = false;
          return false;
        }
      }
      _isRequestingPermissions = false;
      return hasPermissionsResult;
    } else {
      // Handle other platforms (if applicable)
      _isRequestingPermissions = false;
      throw Exception('Platform not supported');
    }
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  Future<DateTime> getLastRetrievedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRetrievedDate = prefs.getString('lastRetrievedDate');
    if (lastRetrievedDate != null) {
      // return DateTime.now().subtract(Duration(days: 4));
      print(lastRetrievedDate);
      return DateTime.parse(lastRetrievedDate);
      // return DateTime.now().subtract(Duration(days: 8));
    }
    return DateTime.now().subtract(Duration(days: 4));
  }

  Future<void> setLastRetrievedDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastRetrievedDate', date.toIso8601String());
  }

  Future<List<HealthDataPoint>> fetchHealthData() async {
    print('@@@@@ Fetching Health Info From Device @@@@@');

    // health.configure(useHealthConnectIfAvailable: true);

    final now = DateTime.now();
    final startTime = await getLastRetrievedDate();
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.WORKOUT,
    ];

    try {
      final dataPoints = await health.getHealthDataFromTypes(
        startTime: startTime,
        endTime: now,
        types: types,
      );

      return dataPoints;
    } catch (e) {
      print('BBBBBBBB');
      print('Error fetching health data: $e');
      return [];
    }
  }

  Future<SyncResult> syncHealthData(
      List<HealthDataPoint> dataPoints, String userId) async {
    print('++ API CALL: SEND HEALTH WORKOUTS');

    final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

    final tMateAppToken = await _secureStorage.read(key: 'tMateAppToken');
    final url = Uri.parse('http://192.168.147.232:3000/device-health');

    final workouts = dataPoints
        .where((point) => point.type == HealthDataType.WORKOUT)
        .map((workout) {
      final workoutValue = workout.value as WorkoutHealthValue;
      final workoutStart = workout.dateFrom;
      final workoutEnd = workout.dateTo;
      final workoutID =
          '${workout.sourceId}_${workout.sourceDeviceId}_${workoutStart.millisecondsSinceEpoch}';

      final workoutHeartRates = dataPoints
          .where((heartRate) =>
              heartRate.type == HealthDataType.HEART_RATE &&
              heartRate.dateFrom.isAfter(workoutStart) &&
              heartRate.dateFrom.isBefore(workoutEnd))
          .map((heartRate) =>
              (heartRate.value as NumericHealthValue).numericValue)
          .toList();

      final averageHeartRate = workoutHeartRates.isNotEmpty
          ? workoutHeartRates.reduce((a, b) => a + b) / workoutHeartRates.length
          : 0;
      final maxHeartRate = workoutHeartRates.isNotEmpty
          ? workoutHeartRates.reduce((a, b) => a > b ? a : b)
          : 0;
      final minHeartRate = workoutHeartRates.isNotEmpty
          ? workoutHeartRates.reduce((a, b) => a < b ? a : b)
          : 0;

      return {
        'workoutId': workoutID,
        'userId': userId,
        'workoutType':
            workoutValue.workoutActivityType.toString().split('.').last,
        'distance': workoutValue.totalDistance ?? 0,
        'distanceUnit':
            workoutValue.totalDistanceUnit.toString().split('.').last,
        'energyBurned': workoutValue.totalEnergyBurned,
        'startDateUtc': workoutStart.toUtc().toIso8601String(),
        'endDateUtc': workoutEnd.toUtc().toIso8601String(),
        'averageHeartRate': averageHeartRate,
        'maxHeartRate': maxHeartRate,
        'sourceName': workout.sourceName,
        'timeOffset': workoutEnd.timeZoneOffset.inSeconds
      };
    }).toList();

    if (workouts.isNotEmpty) {
      final body = jsonEncode({'workouts': workouts});
      print(body);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': tMateAppToken!,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        await setLastRetrievedDate(DateTime.now());
        return SyncResult(success: true, workoutsSynced: workouts.length);
      } else {
        print(response.body);
        return SyncResult(success: false, workoutsSynced: 0);
      }
    } else {
      return SyncResult(success: false, workoutsSynced: 0);
    }
  }

  Future<SyncResult> autoSyncHealthData(String userId) async {
    final permissionsGranted = await requestPermissions();
    if (!permissionsGranted) {
      throw Exception('Permissions not granted');
    }

    final dataPoints = await fetchHealthData();
    return await syncHealthData(dataPoints, userId);
  }

// Gets the Health Connect status on Android.
  Future<void> getHealthConnectSdkStatus() async {
    assert(Platform.isAndroid, "This is only available on Android");

    final status = await Health().getHealthConnectSdkStatus();
    print('Health Connect Status: $status');
  }
}

class SyncResult {
  final bool success;
  final int workoutsSynced;

  SyncResult({required this.success, required this.workoutsSynced});
}

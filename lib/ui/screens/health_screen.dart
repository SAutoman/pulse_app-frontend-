import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pulse_mate_app/providers/auth_provider.dart';
import 'package:pulse_mate_app/services/health/health_service.dart';
import 'package:pulse_mate_app/ui/components/text_toast.dart';

class HealthDataScreen extends StatefulWidget {
  const HealthDataScreen({super.key});

  static String get name => '/health-sync';

  @override
  _HealthDataScreenState createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  bool _isLoading = false;
  bool _syncSuccess = false;
  int _workoutsSynced = 0;

  late FToast fToast;

  Future<void> _syncData() async {
    setState(() {
      _isLoading = true;
      _syncSuccess = false;
      _workoutsSynced = 0;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final healthService = HealthService();

    try {
      final permissionsGranted = await healthService.requestPermissions();
      if (!permissionsGranted) {
        throw Exception('Permissions not granted');
      }

      final dataPoints = await healthService.fetchHealthData();
      final syncResult = await healthService.syncHealthData(
          dataPoints, authProvider.currentUser!.id);

      setState(() {
        _syncSuccess = syncResult.success;
        _workoutsSynced = syncResult.workoutsSynced;
      });

      fToast.showToast(
        child: IconTextToast(
          text: syncResult.success
              ? 'Health data synced successfully: ${syncResult.workoutsSynced} workouts uploaded'
              : 'No workouts to sync',
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sync health data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync Health Data'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  ElevatedButton(
                    onPressed: _syncData,
                    child: Text('Sync Health Data'),
                  ),
                  if (!_isLoading && _syncSuccess)
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text('Sync Status'),
                            subtitle:
                                Text('All workouts were synced successfully.'),
                          ),
                          ListTile(
                            title: Text('Number of Workouts Synced'),
                            subtitle: Text('$_workoutsSynced workouts'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

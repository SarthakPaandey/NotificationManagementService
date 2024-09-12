import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rbuy/NotificationService.dart';
import 'package:rbuy/PreferencesScreen.dart';
import 'package:rbuy/NotificationManagementScreen.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().schedulePersonalizedNotifications();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize OneSignal
    await OneSignal.shared.setAppId("YOUR_ONESIGNAL_APP_ID");
    OneSignal.shared.promptUserForPushNotificationPermission();

    final notificationService = NotificationService();
    await notificationService.init();
  } catch (e) {
    print('Failed to initialize services: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personalized Notification App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            const MyHomePage(title: 'Personalized Notification App'),
        '/preferences': (context) => const PreferencesScreen(),
        '/notifications': (context) => const NotificationManagementScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/preferences');
              },
              child: const Text('Set Notification Preferences'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
              child: const Text('Manage Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}

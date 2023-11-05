import 'package:flutter/material.dart';
import 'package:to_do_app/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_app/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}

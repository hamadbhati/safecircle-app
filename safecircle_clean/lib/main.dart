import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/shared/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/family_service.dart';
import 'services/monitoring_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyARw8lHBUbatCffr-Y5q8uhhUhCP32s7Ew',
      appId: '1:836286896118:android:e607150517ff9b93ad19d7',
      messagingSenderId: '836286896118',
      projectId: 'safecircle-1eb54',
      storageBucket: 'safecircle-1eb54.firebasestorage.app',
    ),
  );
  runApp(const SafeCircleApp());
}

class SafeCircleApp extends StatelessWidget {
  const SafeCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FamilyService()),
        ChangeNotifierProvider(create: (_) => MonitoringService()),
      ],
      child: MaterialApp(
        title: 'SafeCircle',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

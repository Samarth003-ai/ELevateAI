import 'package:flutter/material.dart';
import 'package:resume_builder/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      //creates a single instance of AuthProvider and makes it available to the entire app.
      create: (_) => AuthProvider(),

      child: const ElevateAIApp(),
    ),
  );
}

class ElevateAIApp extends StatelessWidget {
  const ElevateAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      home: const SplashScreen(),
    );
  }
}

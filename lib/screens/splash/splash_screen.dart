import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resume_builder/screens/auth/login_screen.dart';
import '../../core/services/token_service.dart';
import '../dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkLoginStatus() async {
    final token = await TokenService().getToken();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    if (token != null) {
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x0D2563EB), // Primary with 5% opacity
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0x1A2563EB), // Primary with 10% opacity
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.work,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "CareerConnect",
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Build your career, step by step",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

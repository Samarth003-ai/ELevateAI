import 'package:flutter/material.dart';
import 'package:resume_builder/core/services/auth_service.dart';
import 'package:resume_builder/core/services/token_service.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text("Login to continue"),

              const SizedBox(height: 40),

              TextField(
                controller: emailController,

                decoration: const InputDecoration(labelText: "Email"),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,

                obscureText: true,

                decoration: const InputDecoration(labelText: "Password"),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (emailController.text.trim().isEmpty ||
                              passwordController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please enter both email and password")),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final result = await AuthService().login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                            if (result["success"] == true) {
                              await TokenService().saveToken(result["token"]);

                              if (!context.mounted) return;

                              Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).setToken(result["token"]);

                              Navigator.pushReplacement(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => const DashboardScreen(),
                                ),
                              );
                            } else {
                              if (!context.mounted) return;
                              final message = result["message"] ?? "Login failed";
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Connection failed: ${e.toString()}\n"
                                  "Ensure backend is running. (Note: use 10.0.2.2 for Android Emulator, 127.0.0.1/localhost for iOS Simulator, or host computer IP for physical devices)",
                                ),
                                duration: const Duration(seconds: 6),
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },

                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

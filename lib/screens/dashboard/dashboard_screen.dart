import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder/screens/dashboard/home_tab.dart';

import '../../core/services/token_service.dart';
import '../../providers/auth_provider.dart';

import '../auth/login_screen.dart';
import '../jobs/jobs_screen.dart';
import '../profile/profile_screen.dart';
import '../resume/resumes_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeTab(),
      const ResumesScreen(),
      const JobsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Elevate AI"),

        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,

                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),

                    content: const Text("Are you sure you want to logout?"),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text("Cancel"),
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          await TokenService().removeToken();

                          Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          ).logout();

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,

                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),

                            (route) => false,
                          );
                        },

                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "Resume",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resume_builder/core/services/application_service.dart';
import 'package:resume_builder/core/services/profile_service.dart';
import 'package:resume_builder/core/services/resume_service.dart';
import 'package:resume_builder/core/services/saved_job_service.dart';
import 'package:resume_builder/models/application_model.dart';
import 'package:resume_builder/models/resume_model.dart';
import 'package:resume_builder/models/saved_job_model.dart';
import 'package:resume_builder/screens/jobs/application_tracker_screen.dart';
import 'package:resume_builder/screens/jobs/jobs_screen.dart';
import 'package:resume_builder/screens/jobs/saved_jobs_screen.dart';
import 'package:resume_builder/screens/resume/create_resume_screen.dart';
import 'package:resume_builder/screens/chat/chat_screen.dart';


class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<Map<String, dynamic>> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _dashboardDataFuture = _loadDashboardData();
    });
  }

  Future<Map<String, dynamic>> _loadDashboardData() async {
    final profileFuture = ProfileService().getUserProfile().catchError((e) {
      debugPrint("Error loading profile: $e");
      return {"name": "User"};
    });

    final resumesFuture = ResumeService().getResumes().catchError((e) {
      debugPrint("Error loading resumes: $e");
      return <ResumeModel>[];
    });

    final savedJobsFuture = SavedJobService().getSavedJobs().catchError((e) {
      debugPrint("Error loading saved jobs: $e");
      return <SavedJobModel>[];
    });

    final applicationsFuture = ApplicationService()
        .getApplications()
        .catchError((e) {
          debugPrint("Error loading applications: $e");
          return <ApplicationModel>[];
        });

    final results = await Future.wait([
      profileFuture,
      resumesFuture,
      savedJobsFuture,
      applicationsFuture,
    ]);

    return {
      "profile": results[0] as Map<String, dynamic>,
      "resumes": results[1] as List<ResumeModel>,
      "savedJobs": results[2] as List<SavedJobModel>,
      "applications": results[3] as List<ApplicationModel>,
    };
  }

  MaterialColor _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'applied':
        return Colors.blue;
      case 'interview':
        return Colors.amber;
      case 'rejected':
        return Colors.red;
      case 'offer':
        return Colors.green;
      case 'accepted':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2.5,
      shadowColor: const Color(0x0F000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget targetScreen,
  }) {
    return Card(
      elevation: 2,
      shadowColor: const Color(0x06000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[100]!, width: 1),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetScreen),
          );
          _refreshData();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentApplicationTile(ApplicationModel app) {
    final statusColor = _getStatusColor(app.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.business, color: statusColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.company,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  app.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              app.status,
              style: TextStyle(
                color: statusColor.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFEEF2FF), Colors.indigo[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo[100]!, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb, color: Colors.indigo, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "💡 Career Tip",
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Tailor your resume for each application to highlight relevant keywords and match job requirements.",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.indigo[950],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatScreen()),
          );
        },
        backgroundColor: const Color(0xFF1E3A8A),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
          await _dashboardDataFuture;
        },
      child: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final profile = data["profile"] as Map<String, dynamic>;
          final resumes = data["resumes"] as List<ResumeModel>;
          final savedJobs = data["savedJobs"] as List<SavedJobModel>;
          final applications = data["applications"] as List<ApplicationModel>;

          final userName = profile["name"] ?? "User";

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium welcome banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1E3A8A),
                        Color(0xFF3B82F6),
                      ], // Deep blue gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F2563EB),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back 👋",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue[100],
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              userName,
                              style: GoogleFonts.outfit(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Create resumes & track applications",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[50],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white24,
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Resumes",
                        resumes.length.toString(),
                        Icons.description,
                        Colors.indigo,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        "Saved Jobs",
                        savedJobs.length.toString(),
                        Icons.bookmark,
                        Colors.amber[600]!,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildStatCard(
                        "Applications",
                        applications.length.toString(),
                        Icons.assignment_turned_in,
                        Colors.teal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Quick Actions Title
                Text(
                  "Quick Actions",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),

                // Quick actions Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildQuickActionCard(
                      context,
                      title: "Create Resume",
                      icon: Icons.add_box_outlined,
                      color: Colors.blue[700]!,
                      targetScreen: const CreateResumeScreen(),
                    ),
                    _buildQuickActionCard(
                      context,
                      title: "Search Jobs",
                      icon: Icons.search,
                      color: Colors.purple[700]!,
                      targetScreen: const JobsScreen(),
                    ),
                    _buildQuickActionCard(
                      context,
                      title: "Saved Jobs",
                      icon: Icons.bookmark_border,
                      color: Colors.amber[700]!,
                      targetScreen: const SavedJobsScreen(),
                    ),
                    _buildQuickActionCard(
                      context,
                      title: "Applications",
                      icon: Icons.assignment_turned_in_outlined,
                      color: Colors.teal[700]!,
                      targetScreen: const ApplicationTrackerScreen(),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Recent Applications section
                Text(
                  "Recent Applications",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),

                if (applications.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[100]!, width: 1),
                    ),
                    child: const Center(
                      child: Text(
                        "No applications yet. Start applying!",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  )
                else
                  ...applications
                      .take(3)
                      .map((app) => _buildRecentApplicationTile(app)),

                const SizedBox(height: 25),

                // Career Tip Section
                _buildCareerTipCard(),
              ],
            ),
          );
        },
      ),
    ),
  );
}
}

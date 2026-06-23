import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resume_builder/core/services/pdf_service.dart';
import 'package:resume_builder/screens/resume/create_resume_screen.dart';
import 'package:resume_builder/screens/resume/edit_resume_screen.dart';

import '../../core/services/resume_service.dart';
import '../../models/resume_model.dart';

class ResumesScreen extends StatefulWidget {
  const ResumesScreen({super.key});

  @override
  State<ResumesScreen> createState() => _ResumesScreenState();
}

class _ResumesScreenState extends State<ResumesScreen> {
  late Future<List<ResumeModel>> resumesFuture;

  @override
  void initState() {
    super.initState();
    _refreshResumes();
  }

  void _refreshResumes() {
    setState(() {
      resumesFuture = ResumeService().getResumes();
    });
  }

  String _getTemplateLabel(String template) {
    if (template == "modern_blue") return "Modern Blue";
    if (template == "ats_friendly") return "ATS Friendly";
    return template;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: FutureBuilder<List<ResumeModel>>(
        future: resumesFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final resumes = snapshot.data ?? [];

          if (resumes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No Resumes Found",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Create your first professional resume now!",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: resumes.length,

            itemBuilder: (context, index) {
              final resume = resumes[index];
              final isModernBlue = resume.template == "modern_blue";

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shadowColor: const Color(0x0A000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey[100]!, width: 1),
                ),
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => EditResumeScreen(resumeId: resume.id),
                      ),
                    );
                    _refreshResumes();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Thumbnail visual representation
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isModernBlue
                                  ? [const Color(0xFF1565C0), const Color(0xFF42A5F5)]
                                  : [const Color(0xFF37474F), const Color(0xFF78909C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.article,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Center content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resume.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isModernBlue
                                      ? const Color(0xE3EBF8FF)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _getTemplateLabel(resume.template),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isModernBlue
                                        ? const Color(0xFF2B6CB0)
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right action
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0x0D2563EB),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.picture_as_pdf,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () async {
                              await PdfService().downloadPdf(resume.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const CreateResumeScreen()),
          );
          _refreshResumes();
        },

        icon: const Icon(Icons.add),
        label: Text(
          "Create Resume",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

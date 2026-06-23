import 'package:flutter/material.dart';

import '../../core/services/resume_service.dart';
import '../../models/resume_model.dart';

class EditResumeScreen extends StatefulWidget {
  final String resumeId;

  const EditResumeScreen({super.key, required this.resumeId});

  @override
  State<EditResumeScreen> createState() => _EditResumeScreenState();
}

class _EditResumeScreenState extends State<EditResumeScreen> {
  final titleController = TextEditingController();
  final summaryController = TextEditingController();
  final skillController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final linkedinController = TextEditingController();
  final githubController = TextEditingController();

  List<dynamic> skills = [];
  List<dynamic> education = [];
  List<dynamic> experience = [];
  List<dynamic> projects = [];

  bool isLoading = false;
  bool isDataInitialized = false;

  late Future<ResumeModel> resumeFuture;

  @override
  void initState() {
    super.initState();
    resumeFuture = ResumeService().getResumeById(widget.resumeId);
  }

  @override
  void dispose() {
    titleController.dispose();
    summaryController.dispose();
    skillController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    linkedinController.dispose();
    githubController.dispose();
    super.dispose();
  }

  void _showAddEducationDialog() {
    final collegeController = TextEditingController();
    final degreeController = TextEditingController();
    final cgpaController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Education"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: collegeController,
                  decoration: const InputDecoration(labelText: "College/University"),
                ),
                TextField(
                  controller: degreeController,
                  decoration: const InputDecoration(labelText: "Degree/Course"),
                ),
                TextField(
                  controller: cgpaController,
                  decoration: const InputDecoration(labelText: "CGPA/GPA"),
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: "Duration (e.g. 2019 - 2023)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (collegeController.text.trim().isEmpty ||
                    degreeController.text.trim().isEmpty) {
                  return;
                }
                setState(() {
                  education.add({
                    "college": collegeController.text.trim(),
                    "degree": degreeController.text.trim(),
                    "cgpa": cgpaController.text.trim(),
                    "duration": durationController.text.trim(),
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showAddExperienceDialog() {
    final companyController = TextEditingController();
    final roleController = TextEditingController();
    final durationController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Experience"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(labelText: "Company Name"),
                ),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: "Role/Designation"),
                ),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: "Duration (e.g. 2024 - Present)"),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    hintText: "Enter description (bullet points supported)",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (companyController.text.trim().isEmpty ||
                    roleController.text.trim().isEmpty) {
                  return;
                }
                setState(() {
                  experience.add({
                    "company": companyController.text.trim(),
                    "role": roleController.text.trim(),
                    "duration": durationController.text.trim(),
                    "description": descriptionController.text.trim(),
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showAddProjectDialog() {
    final projectTitleController = TextEditingController();
    final projectDescController = TextEditingController();
    final techStackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Project"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: projectTitleController,
                  decoration: const InputDecoration(labelText: "Project Title"),
                ),
                TextField(
                  controller: projectDescController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Project Description"),
                ),
                TextField(
                  controller: techStackController,
                  decoration: const InputDecoration(
                    labelText: "Tech Stack",
                    hintText: "Enter technologies separated by commas",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (projectTitleController.text.trim().isEmpty) {
                  return;
                }
                final techs = techStackController.text
                    .split(",")
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                setState(() {
                  projects.add({
                    "title": projectTitleController.text.trim(),
                    "description": projectDescController.text.trim(),
                    "techStack": techs,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Resume")),

      body: FutureBuilder<ResumeModel>(
        future: resumeFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final resume = snapshot.data!;

          if (!isDataInitialized) {
            skills = List.from(resume.skills);
            education = List.from(resume.education);
            experience = List.from(resume.experience);
            projects = List.from(resume.projects);

            nameController.text = resume.personalInfo["name"] ?? "";
            emailController.text = resume.personalInfo["email"] ?? "";
            phoneController.text = resume.personalInfo["phone"] ?? "";
            addressController.text = resume.personalInfo["address"] ?? "";
            linkedinController.text = resume.personalInfo["linkedin"] ?? "";
            githubController.text = resume.personalInfo["github"] ?? "";
            titleController.text = resume.title;
            summaryController.text = resume.summary;

            isDataInitialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "General Info",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Resume Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: linkedinController,
                  decoration: const InputDecoration(
                    labelText: "LinkedIn URL",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: githubController,
                  decoration: const InputDecoration(
                    labelText: "GitHub URL",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: summaryController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Professional Summary",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // Skills section
                const Text(
                  "Skills",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: skills.map((skill) {
                    return Chip(
                      label: Text(skill),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          skills.remove(skill);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: skillController,
                        decoration: const InputDecoration(
                          labelText: "Add Skill",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (skillController.text.trim().isEmpty) {
                          return;
                        }
                        setState(() {
                          skills.add(skillController.text.trim());
                        });
                        skillController.clear();
                      },
                      child: const Text("Add"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Education Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Education",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: _showAddEducationDialog,
                      icon: const Icon(Icons.add),
                      label: const Text("Add"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...education.map((edu) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text("${edu['degree']} - ${edu['college']}"),
                      subtitle: Text(
                        "GPA: ${edu['cgpa'] ?? 'N/A'} | ${edu['duration'] ?? ''}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            education.remove(edu);
                          });
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 25),

                // Experience Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Experience",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: _showAddExperienceDialog,
                      icon: const Icon(Icons.add),
                      label: const Text("Add"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...experience.map((exp) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text("${exp['role']} at ${exp['company']}"),
                      subtitle: Text(exp['duration'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            experience.remove(exp);
                          });
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 25),

                // Projects Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Projects",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: _showAddProjectDialog,
                      icon: const Icon(Icons.add),
                      label: const Text("Add"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...projects.map((proj) {
                  final techList = proj['techStack'] is List
                      ? (proj['techStack'] as List).join(", ")
                      : proj['techStack'].toString();
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(proj['title'] ?? ''),
                      subtitle: Text("Technologies: $techList"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            projects.remove(proj);
                          });
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 40),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (titleController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Title is required"),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await ResumeService().updateResume(
                                id: widget.resumeId,
                                title: titleController.text.trim(),
                                summary: summaryController.text.trim(),
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                phone: phoneController.text.trim(),
                                address: addressController.text.trim(),
                                linkedin: linkedinController.text.trim(),
                                github: githubController.text.trim(),
                                skills: skills,
                                education: education,
                                experience: experience,
                                projects: projects,
                              );

                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Resume Updated")),
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
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
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save Changes",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:resume_builder/screens/jobs/saved_jobs_screen.dart';

import '../../core/services/job_service.dart';
import '../../core/services/saved_job_service.dart';
import '../../models/job_model.dart';
import 'package:url_launcher/url_launcher.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final searchController = TextEditingController();

  List<JobModel> jobs = [];

  bool isLoading = false;

  Future<void> saveJob(JobModel job) async {
    try {
      await SavedJobService().saveJob(
        jobId: job.jobId,
        title: job.title,
        company: job.company,
        location: job.location,
        applyLink: job.applyLink,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Job Saved")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> searchJobs() async {
    if (searchController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await JobService().searchJobs(
        searchController.text.trim(),
      );

      setState(() {
        jobs = result;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //apply function
  Future<void> openApplyLink(String url) async {
    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (_) => const SavedJobsScreen()),
              );
            },

            icon: const Icon(Icons.bookmark),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: searchController,

              decoration: const InputDecoration(
                labelText: "Search Jobs",

                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : searchJobs,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Search"),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,

                itemBuilder: (context, index) {
                  final job = jobs[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),

                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            job.title,

                            style: const TextStyle(
                              fontSize: 16,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(job.company),

                          Text(job.location),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  saveJob(job);
                                },

                                child: const Text("Save"),
                              ),

                              const SizedBox(width: 10),

                              ElevatedButton(
                                onPressed: () {
                                  openApplyLink(job.applyLink);
                                },

                                child: const Text("Apply"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

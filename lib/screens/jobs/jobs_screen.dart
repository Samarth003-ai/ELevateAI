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

  List<JobModel> matchedJobs = [];
  bool isMatchedLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMatchedJobs();
  }

  Future<void> fetchMatchedJobs() async {
    setState(() {
      isMatchedLoading = true;
    });

    try {
      final result = await JobService().getMatchedJobs();
      setState(() {
        matchedJobs = result;
      });
    } catch (e) {
      debugPrint("Failed to load matched jobs: $e");
    } finally {
      setState(() {
        isMatchedLoading = false;
      });
    }
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

            if (isMatchedLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (matchedJobs.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Opportunities for you ✨",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 145,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: matchedJobs.length,
                  itemBuilder: (context, index) {
                    final job = matchedJobs[index];
                    return Container(
                      width: 270,
                      margin: const EdgeInsets.only(right: 12, bottom: 4),
                      child: Card(
                        elevation: 2,
                        shadowColor: const Color(0x0A000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[100]!, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      job.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      job.company,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      job.location,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => saveJob(job),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text("Save"),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => openApplyLink(job.applyLink),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      "Apply",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (jobs.isNotEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Search Results",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),

            Expanded(
              child: jobs.isEmpty
                  ? Center(
                      child: Text(
                        isLoading ? "" : "Search for jobs to get started",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    )
                  : ListView.builder(
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

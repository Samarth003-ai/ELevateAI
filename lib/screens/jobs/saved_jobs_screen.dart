import 'package:flutter/material.dart';
import 'package:resume_builder/core/services/application_service.dart';
import 'package:resume_builder/core/services/saved_job_service.dart';
import '../../models/saved_job_model.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  late Future<List<SavedJobModel>> jobsFuture;

  Future<void> trackApplication(SavedJobModel job) async {
    try {
      await ApplicationService().createApplication(
        title: job.title,

        company: job.company,
      );

      await SavedJobService().deleteSavedJob(job.id);

      if (!mounted) {
        return;
      }

      setState(() {
        jobsFuture = SavedJobService().getSavedJobs();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Application Added")));
    } catch (e) {
      if (!mounted) {
        return;
      }
      final message = e.toString().replaceAll("Exception: ", "");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void initState() {
    super.initState();

    jobsFuture = SavedJobService().getSavedJobs();
  }

  Future<void> deleteJob(String id) async {
    await SavedJobService().deleteSavedJob(id);

    setState(() {
      jobsFuture = SavedJobService().getSavedJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Jobs")),

      body: FutureBuilder<List<SavedJobModel>>(
        future: jobsFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final jobs = snapshot.data!;

          if (jobs.isEmpty) {
            return const Center(child: Text("No Saved Jobs"));
          }

          return ListView.builder(
            itemCount: jobs.length,

            itemBuilder: (context, index) {
              final job = jobs[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  title: Text(job.title),

                  subtitle: Text(job.company),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      IconButton(
                        icon: const Icon(Icons.work),

                        onPressed: () => trackApplication(job),
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete),

                        onPressed: () {
                          deleteJob(job.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

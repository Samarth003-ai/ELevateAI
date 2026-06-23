import 'package:flutter/material.dart';

import '../../core/services/application_service.dart';

import '../../models/application_model.dart';

class ApplicationTrackerScreen extends StatefulWidget {
  const ApplicationTrackerScreen({super.key});

  @override
  State<ApplicationTrackerScreen> createState() =>
      _ApplicationTrackerScreenState();
}

class _ApplicationTrackerScreenState extends State<ApplicationTrackerScreen> {
  late Future<List<ApplicationModel>> applicationsFuture;

  @override
  void initState() {
    super.initState();

    applicationsFuture = ApplicationService().getApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Applications")),

      body: FutureBuilder<List<ApplicationModel>>(
        future: applicationsFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final applications = snapshot.data!;

          return ListView.builder(
            itemCount: applications.length,

            itemBuilder: (context, index) {
              final app = applications[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(app.title),

                      Text(app.company),

                      const SizedBox(height: 10),

                      DropdownButton<String>(
                        value: app.status,

                        items:
                            [
                              "Applied",

                              "Interview",

                              "Rejected",

                              "Offer",

                              "Accepted",
                            ].map((status) {
                              return DropdownMenuItem(
                                value: status,

                                child: Text(status),
                              );
                            }).toList(),

                        onChanged: (value) async {
                          await ApplicationService().updateStatus(
                            id: app.id,

                            status: value!,
                          );

                          setState(() {
                            applicationsFuture = ApplicationService()
                                .getApplications();
                          });
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

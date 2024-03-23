import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import 'report_screen.dart';

class ReportsListScreen extends StatefulWidget {
  String userID = AuthenticationRepository.instance.authUser!.uid;
  String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;

  ReportsListScreen({super.key});

  @override
  _ReportsListScreenState createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  late Future<List<String>> _fileUrls;

  @override
  void initState() {
    super.initState();
    _fileUrls = StorageService().listReportFiles(widget.userID, widget.vehicleNo);
  }

  @override
  Widget build(BuildContext context) {
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _fileUrls,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No reports found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // Get the file name from the download link
                    final Uri url = Uri.parse(snapshot.data![index]);
                    String fileName = url.pathSegments.last;
                    fileName = fileName.split('/').last; // Extract the file name// Extract the file name

                    return ListTile(
                      title: Text('Report ${index + 1} - $fileName'),
                      onTap: () async {
                        final Uri url = Uri.parse(snapshot.data![index]);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Could not launch ${url.toString()}"),
                            ),
                          );
                        }
                      },
                    );
                  },
                );

              },
            ),
          ),

          const Divider(),
          Text(
            "Generated Reports of $vehicleNo",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Add New Record'),
                onPressed: () {
                  // Navigate to the ServiceRecordForm screen
                  Get.to(() => ReportScreen()); // Ensure this navigates correctly based on your app's routing setup
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> listReportFiles(String userId, String vehicleNo) async {
    List<String> fileUrls = [];

    // Reference to the reports directory
    final reportsRef = _storage.ref('$userId/$vehicleNo/Reports');

    try {
      // List all items (files) under the given reference
      final result = await reportsRef.listAll();

      // For each file item, get the download URL and add it to the list
      for (var item in result.items) {
        final url = await item.getDownloadURL();
        fileUrls.add(url);
      }
    } catch (e) {
      print("Error listing files: $e");
    }

    return fileUrls;
  }
}


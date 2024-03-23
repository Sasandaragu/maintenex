import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../common/widgets/confirmation.dart';
import '../controllers/service_records_controllers.dart';
import '../models/service_record/service_record_model.dart';

class ServiceRecordDetailScreen extends StatelessWidget {
  final ServiceRecordModel serviceRecord;

  const ServiceRecordDetailScreen({Key? key, required this.serviceRecord})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Record Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(
              context,
              'Service Provider:',
              serviceRecord.serviceProvider,
            ),
            _buildDetailItem(
              context,
              'Date:',
              serviceRecord.date,
            ),
            if (serviceRecord.recommendedMileage != null)
              _buildDetailItem(
                context,
                'Recommended Mileage:',
                serviceRecord.recommendedMileage.toString(),
              ),
            if (serviceRecord.recommendedLifetime != null)
              _buildDetailItem(
                context,
                'Recommended Lifetime:',
                serviceRecord.recommendedLifetime.toString(),
              ),
            _buildDetailItem(
              context,
              'Total Cost:',
              '${serviceRecord.totalCost}',
            ),
            _buildDetailItem(
              context,
              'Description:',
              serviceRecord.description,
            ),

            _buildDetailItem(
              context,
              'Receive Alerts:',
              serviceRecord.enableAlert ? 'Yes' : 'No',
            ),

            if (serviceRecord.fileUrls != null && serviceRecord.fileUrls!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Attached Files:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: serviceRecord.fileUrls!
                        .map(
                          (url) {
                            final Uri urlClick = Uri.parse(url);
                            String fileName = urlClick.pathSegments.last;
                            fileName = fileName.split('/').last; // Get the file name from the URL
                            return GestureDetector(
                              onTap: () async {                          
                                if (await canLaunchUrl(urlClick)) {
                                  await launchUrl(urlClick);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Could not launch ${url.toString()}"),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                fileName,
                                style: TextStyle(
                                  color: Colors.blue, // Change the text color to blue
                                  decoration: TextDecoration.underline, // Add underline effect
                                ),
                              ),
                            );
                          },
                        )
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Button to delete PDF
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    message: 'Are you sure you want to proceed?',
                    onYesPressed: () async {
                      final controller = ServiceRecordController();
                      await controller.deleteServiceRecord(serviceRecord: serviceRecord);                 
                    },
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
            // Button to remove alerts
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    message: 'Are you sure you want to proceed?',
                    onYesPressed: () async {
                      final controller = ServiceRecordController();
                      await controller.removeAlert(serviceRecord: serviceRecord);                 
                    },
                  ),
                );
              },
              child: Text('Remove Alert'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 28, 35, 41),
              ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Divider(),
      ],
    );
  }
}

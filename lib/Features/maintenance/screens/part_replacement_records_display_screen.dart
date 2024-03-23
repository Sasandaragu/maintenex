import 'package:flutter/material.dart';
import 'package:maintenex/Features/maintenance/controllers/part_replacement_records_controllers.dart';
import 'package:maintenex/Features/maintenance/models/part_replacement_record/part_raplacement_record_model.dart';
import 'package:maintenex/common/widgets/confirmation.dart';
import 'package:url_launcher/url_launcher.dart';

class PartReplacementRecordDetailScreen extends StatelessWidget {
  final PartReplacementRecordModel partReplacementRecord;

  const PartReplacementRecordDetailScreen({
    Key? key,
    required this.partReplacementRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Part Replacement Record Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(
              context,
              'Service Provider:',
              partReplacementRecord.serviceProvider,
            ),
            _buildDetailItem(
              context,
              'Date:',
              partReplacementRecord.date,
            ),
            if (partReplacementRecord.recommendedMileage != null)
              _buildDetailItem(
                context,
                'Recommended Mileage:',
                partReplacementRecord.recommendedMileage.toString(),
              ),
            if (partReplacementRecord.recommendedLifetime != null)
              _buildDetailItem(
                context,
                'Recommended Lifetime:',
                partReplacementRecord.recommendedLifetime.toString(),
              ),
            _buildDetailItem(
              context,
              'Total Cost:',
              '${partReplacementRecord.totalCost}',
            ),
            _buildDetailItem(
              context,
              'Description:',
              partReplacementRecord.description,
            ),
            _buildDetailItem(
              context,
              'Receive Alerts:',
              partReplacementRecord.enableAlert ? 'Yes' : 'No',
            ),

            if (partReplacementRecord.fileUrls != null && partReplacementRecord.fileUrls!.isNotEmpty)
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
                    children: partReplacementRecord.fileUrls!
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
                      final controller = PartReplacementRecordController();
                      await controller.deletePartReplacementRecord(
                          partReplacementRecord: partReplacementRecord);
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
                      final controller = PartReplacementRecordController();
                      await controller.removeAlert(
                          partReplacementRecord: partReplacementRecord);
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
                color: Color.fromARGB(255, 92, 95, 98),
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

  void _showDeleteConfirmationDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to $action?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform delete action here
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}

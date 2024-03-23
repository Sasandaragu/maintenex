import 'package:flutter/material.dart';
import 'package:maintenex/Features/maintenance/models/repair_record/repair_record_model.dart';

class RepairRecordDetailScreen extends StatelessWidget {
  final RepairRecordModel repairRecord;

  const RepairRecordDetailScreen({Key? key, required this.repairRecord})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repair Record Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(
              context,
              'Service Provider:',
              repairRecord.serviceProvider,
            ),
            _buildDetailItem(
              context,
              'Date:',
              repairRecord.date,
            ),
            _buildDetailItem(
              context,
              'Total Cost:',
              '${repairRecord.totalCost}',
            ),
            _buildDetailItem(
              context,
              'Description:',
              repairRecord.description,
            ),
            if (repairRecord.fileUrls != null &&
                repairRecord.fileUrls!.isNotEmpty)
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
                    children: repairRecord.fileUrls!
                        .map((url) => Text(
                              url,
                              style: Theme.of(context).textTheme.bodyText1,
                            ))
                        .toList(),
                  ),
                ],
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
}

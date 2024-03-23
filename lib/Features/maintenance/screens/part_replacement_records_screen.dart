import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/maintenance/models/part_replacement_record/part_raplacement_record_model.dart';
import 'package:maintenex/Features/maintenance/screens/Records_description_screen.dart';
import 'package:maintenex/Features/maintenance/screens/part_replacement_records_display_screen.dart';
import 'package:maintenex/Features/maintenance/screens/part_replacement_records_form_screen.dart';
import 'package:maintenex/common/widgets/appbar.dart';
import 'package:maintenex/data/repositories/maintenex/part_replacement/partReplacementRecordRepository.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class PartReplacementRecordsScreen extends StatefulWidget {
  const PartReplacementRecordsScreen({Key? key}) : super(key: key);

  @override
  _PartReplacementRecordsScreenState createState() =>
      _PartReplacementRecordsScreenState();
}

class _PartReplacementRecordsScreenState
    extends State<PartReplacementRecordsScreen> {
  final PartReplacementRecordRepository _repository =
      PartReplacementRecordRepository();
  late Future<List<PartReplacementRecordModel>> partReplacementRecords;
  final currentVehicle = VehicleRepository.instance.currentVehicle.vehicleNo;

  @override
  void initState() {
    super.initState();
    // Wrap the fetchServiceRecords call in a try-catch block
    partReplacementRecords = _fetchServiceRecords();
  }

  Future<List<PartReplacementRecordModel>> _fetchServiceRecords() async {
    try {
      final records = await _repository.fetchPartReplacementRecords();
      // Sort the records by date
      records.sort((a, b) {
        DateTime dateA = DateTime.parse(a.date);
        DateTime dateB = DateTime.parse(b.date);
        return dateB.compareTo(dateA); // For descending order
      });
      return records;
    } catch (error) {
      // Print the error message and return an empty list
      MLoaders.errorSnackBar(
          title: 'Select a Vehicle First', message: error.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
          title: const Text('Part Replacement Records',
              style: TextStyle(color: Colors.black)),
          showBackArrow: false,
          leadingIcon: Icons.arrow_back,
          leadingOnPressed: () => Get.to(() =>
              const ExplanationScreen()) 

          ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/logos/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<PartReplacementRecordModel>>(
          future: partReplacementRecords,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final partReplacementRecords = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: partReplacementRecords.length,
                      itemBuilder: (context, index) {
                        final record = partReplacementRecords[index];
                        return ListTile(
                          title: Text(record.serviceProvider),
                          subtitle: Text(record.date),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PartReplacementRecordDetailScreen(
                                    partReplacementRecord: record,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Text(
                    "Part Replacement Records of $currentVehicle",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          child: const Text('Add New Record'),
                          onPressed: () =>
                              Get.to(() => PartReplacementRecordForm())),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                  child: Text('No Part Replacement Records Found'));
            }
          },
        ),
      ),
    );
  }
}

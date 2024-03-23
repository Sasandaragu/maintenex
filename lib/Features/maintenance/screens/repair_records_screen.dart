import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/maintenance/models/repair_record/repair_record_model.dart';
import 'package:maintenex/Features/maintenance/screens/Records_description_screen.dart';
import 'package:maintenex/Features/maintenance/screens/repair_records_display_screen.dart';
import 'package:maintenex/Features/maintenance/screens/repair_records_form_screen.dart';
import 'package:maintenex/common/widgets/appbar.dart';
import 'package:maintenex/data/repositories/maintenex/repair_record/repairRecordRepository.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class RepairRecordsScreen extends StatefulWidget {
  const RepairRecordsScreen({Key? key}) : super(key: key);

  @override
  _RepairRecordsScreenState createState() => _RepairRecordsScreenState();
}

class _RepairRecordsScreenState extends State<RepairRecordsScreen> {
  final RepairRecordRepository _repository = RepairRecordRepository();
  late Future<List<RepairRecordModel>> repairRecords;
  final currentVehicle = VehicleRepository.instance.currentVehicle.vehicleNo;

    @override
  void initState() {
    super.initState();
    // Wrap the fetchServiceRecords call in a try-catch block
    repairRecords = _fetchServiceRecords();
  }

  Future<List<RepairRecordModel>> _fetchServiceRecords() async {
    try {
      final records = await _repository.fetchRepairRecords();
      // Sort the records by date
      records.sort((a, b) {
        DateTime dateA = DateTime.parse(a.date);
        DateTime dateB = DateTime.parse(b.date);
        return dateB.compareTo(dateA); // For descending order
      });
      return records;
    } catch (error) {
      // Print the error message and return an empty list
      MLoaders.errorSnackBar(title: 'Select a Vehicle First',message: error.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
          title: const Text('Repair Records',
              style: TextStyle(
                  color: Colors
                      .black)), // Ensure the title style matches your app's theme
          showBackArrow: false,
          leadingIcon: Icons.arrow_back,
          leadingOnPressed: () => Get.to(() =>
              const ExplanationScreen()) // Adjust if using a different navigation method
          ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/logos/background.jpg"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<RepairRecordModel>>(
          future: repairRecords,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final repairRecords = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: repairRecords.length,
                      itemBuilder: (context, index) {
                        final record = repairRecords[index];
                        return ListTile(
                          title: Text(record.serviceProvider),
                          subtitle: Text(record.date),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => RepairRecordDetailScreen(
                                      repairRecord: record)));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Text(
                    "Repair Records of $currentVehicle",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          child: const Text('Add New Record'),
                          onPressed: () => Get.to(() => RepairRecordForm())),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No Repair Records Found'));
            }
          },
        ),
      ),
    );
  }
}

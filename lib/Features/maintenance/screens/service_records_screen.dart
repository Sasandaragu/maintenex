import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/appbar.dart';
import '../../../data/repositories/maintenex/service_record/serviceRecordRepository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import '../../../utils/poppups/loaders.dart';
import '../models/service_record/service_record_model.dart';
import 'Records_description_screen.dart';
import 'service_records_display_screen.dart';
import 'service_records_form_screen.dart';


class ServiceRecordsScreen extends StatefulWidget {
  const ServiceRecordsScreen({super.key});

  @override
  _ServiceRecordsScreenState createState() => _ServiceRecordsScreenState();
}

class _ServiceRecordsScreenState extends State<ServiceRecordsScreen> {

  final ServiceRecordRepository _repository = ServiceRecordRepository();
  late Future<List<ServiceRecordModel>> serviceRecords;
  final currentVehicle = VehicleRepository.instance.currentVehicle.vehicleNo;

  @override
  void initState() {
    super.initState();
    // Wrap the fetchServiceRecords call in a try-catch block
    serviceRecords = _fetchServiceRecords();
  }

  Future<List<ServiceRecordModel>> _fetchServiceRecords() async {
    try {
      final records = await _repository.fetchServiceRecords();
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
          title: const Text('Service Records',
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
        child: FutureBuilder<List<ServiceRecordModel>>(
          future: serviceRecords,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final serviceRecords = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: serviceRecords.length,
                      itemBuilder: (context, index) {
                        final record = serviceRecords[index];
                        return ListTile(
                          title: Text(record.serviceProvider),
                          subtitle: Text(record.date),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ServiceRecordDetailScreen(
                                      serviceRecord: record)));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Text(
                    "Service Records of $currentVehicle",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          child: const Text('Add New Record'),
                          onPressed: () => Get.to(() => ServiceRecordForm())),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No Service Records Found'));
            }
          },
        ),
      ),
    );
  }
}

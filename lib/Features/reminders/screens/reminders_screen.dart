// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/appbar.dart';
import '../../../data/repositories/maintenex/part_replacement/partReplacementRecordRepository.dart';
import '../../../data/repositories/maintenex/service_record/serviceRecordRepository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import '../../../utils/poppups/loaders.dart';
import '../../Home/screens/home_screens.dart';
import '../../maintenance/models/part_replacement_record/part_raplacement_record_model.dart';
import '../../maintenance/models/service_record/service_record_model.dart';
import '../../maintenance/screens/part_replacement_records_display_screen.dart';
import '../../maintenance/screens/service_records_display_screen.dart';
import '../controllers/remindersController.dart';
import '../models/milestone_model.dart';


class ReminderScreen extends StatefulWidget {
 
 const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final ReminderController controller = ReminderController();
  final PartReplacementRecordRepository partReplace_repository = PartReplacementRecordRepository();
  final ServiceRecordRepository service_repository = ServiceRecordRepository();
  late Future<List<ServiceRecordModel>> serviceRecords;
  final currentVehicle = VehicleRepository.instance.currentVehicle.vehicleNo;
  late Future<List<MileStoneModel>> reminders;
  late Future<List<PartReplacementRecordModel>> replacementRecords;

   @override
     void initState() {
    super.initState();
    reminders =controller.fetchMilestones();
    replacementRecords = _fetchReplacementRecords();
    serviceRecords = _fetchServiceRecords();
  }

  Future<List<PartReplacementRecordModel>> _fetchReplacementRecords() async {
    try {
      final records = await partReplace_repository.fetchRelevantPartReplacementRecord();
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

  Future<List<ServiceRecordModel>> _fetchServiceRecords() async {
    try {
      final records = await service_repository.fetchRelevantServiceRecords();
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

  void navigateToPartReplacementRecordDetail(String title) async {
    try {
      // Await the completion of the future to get the list of replacement records
      List<PartReplacementRecordModel> records = await replacementRecords;
      
      // Filter the replacement records to find the matching record
      PartReplacementRecordModel? matchingRecord = records.firstWhere(
        (record) => title.contains(record.replacedPart),
      );
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PartReplacementRecordDetailScreen(
            partReplacementRecord: matchingRecord,
          ),
        ),
      );
    // ignore: empty_catches
    } catch (error) {
      } 
  }

  void navigateToServiceRecordDetail(String date) async {
    try {
      // Await the completion of the future to get the list of service records
      List<ServiceRecordModel> records = await serviceRecords; 
      
      // Filter the service records to find the matching record
      ServiceRecordModel? matchingRecord = records.firstWhere(
        (record) => record.date == date,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ServiceRecordDetailScreen(
            serviceRecord: matchingRecord,
          ),
        ),
      );
    } catch (error) {
      // Handle errors if any
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occurred while fetching service records.'),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
          title: const Text('Daily Reminders',
              style: TextStyle(
                  color: Colors
                      .black)), 
          showBackArrow: false,
          leadingIcon: Icons.arrow_back,
          leadingOnPressed: () => Get.to(() =>
              const HomeScreen()) 
          ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/logos/background.jpg"), 
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<MileStoneModel>>(
          future: reminders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final reminders = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final milestone = reminders[index];
                        return ListTile(
                          title: Text(milestone.title),
                          subtitle: Text("Alert Mileage: ${milestone.alertMileage}"),
                          /*trailing: IconButton(
                            icon: const Icon(Icons.notifications_off_sharp),
                            color: Color.fromARGB(255, 117, 109, 186),
                            onPressed: () {
                              navigateToPartReplacementRecordDetail(milestone.title);
                            },
                          )*/
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              navigateToPartReplacementRecordDetail(milestone.title);
                              if(milestone.recordType=="Service Record"){
                                navigateToServiceRecordDetail(milestone.date);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                  child: Text('No Upcoming Daliy Reminders Found'));
            }
          },
        ),
      ),
    );
  }
}

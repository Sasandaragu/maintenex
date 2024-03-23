import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/appbar.dart';
import '../../../data/repositories/mileage/mileage_repository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import '../../Home/screens/home_screens.dart';
import '../../personalization/controllers/user_controller.dart';
import '../controllers/mileageControllers.dart';
import '../models/mileage_record_model.dart';
import 'addMileage.dart';



class MileageTrackingApp extends StatefulWidget {
  const MileageTrackingApp({super.key});
  
  @override
  _MileageTrackingAppState createState() => _MileageTrackingAppState();
}

class _MileageTrackingAppState extends State<MileageTrackingApp> {
  final MileageController _controller = MileageController();
  final MileageRepository mileageRepository = MileageRepository();
  late Future<List<MileageRecordModel>> mileageRecords;
  final currentVehicle = VehicleRepository.instance.currentVehicle.vehicleNo;


  double mileageWhenStarted = 10000.0;
  double mileageTillNow = 0.0;

  @override
  void initState() {
    super.initState();
    mileageRecords = mileageRepository.fetchMileageRecords().then((records) {
      records.sort((a, b) {
        DateTime dateA = DateTime.parse(a.date);
        DateTime dateB = DateTime.parse(b.date);
        return dateB.compareTo(dateA); // For descending order
      });
      return records;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'Mileage Tracking',
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 30.0,
  //         ),
  //       ),
  //       centerTitle: true,
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //     ),
  //     body: Column(
  //       children: <Widget>[
  //         Container(
  //           margin: const EdgeInsets.only(
  //               top: 5, left: 5.0, right: 5.0, bottom: 20),
  //           child: MileageInfoBox(appState: this),
  //         ),
  //         Expanded(
  //           child: ListView.builder(
  //             itemCount: mileageRecords.length,
  //             itemBuilder: (context, index) {
  //               final record = serviceRecords[index];
  //               return ListTile(
  //                 title: Text(record.serviceProvider),
  //                 subtitle: Text(record.date),
  //                 trailing: IconButton(
  //                   icon: Icon(Icons.arrow_forward_ios),
  //                   onPressed: (){}
  //                 ),
  //               );
  //             },
  //           ),
  //                 ),
  //       ],
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () => addMileage(context),
  //       child: Icon(Icons.add),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(100),
  //       ),
  //       foregroundColor: Colors.white,
  //       backgroundColor: Colors.black, // Button color for add
  //       elevation: 0,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    return Scaffold(
      appBar: TAppBar(
          title: const Text('Mileage Records',
              style: TextStyle(
                  color: Colors
                      .black)), // Ensure the title style matches your app's theme
          showBackArrow: false,
          leadingIcon: Icons.arrow_back,
          leadingOnPressed: () => Get.to(() =>
              const HomeScreen()) // Adjust if using a different navigation method
          ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/logos/background.jpg"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<MileageRecordModel>>(
          future: mileageRecords,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final mileageRecords = snapshot.data!;
              return Column(
                children: [
                  // Add MileageInfoBox here
                  Container(
                    margin: const EdgeInsets.only(
                        top: 5, left: 5.0, right: 5.0, bottom: 20),
                    child: MileageInfoBox(appState: this),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: mileageRecords.length,
                      itemBuilder: (context, index) {
                        final record = mileageRecords[index];
                        return ListTile(
                          title: Text('${record.preMileage.toString()} --> ${record.newMileage.toString()} (+${record.difference.toString()})'),
                          subtitle: Text(record.date),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {},
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Text(
                    "Mileage Records of $currentVehicle",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          child: const Text('Add New Record'),
                          onPressed:() => addMileage(context)),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No Mileage Records Found'));
            }
          },
        ),
      ),
    );
  }


  double calculateMileageTraveledTillNow(
      double mileageWhenStarted, double mileageTillNow) {
    mileageTillNow += _controller.currentMileage - mileageWhenStarted;
    return mileageTillNow;
  }

  void addMileage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMileageScreen(
          onMileageAdded: (mileageEntry) {
            setState(() {
              _controller.addMileage(mileageEntry);
            });
          },
        ),
      ),
    );
  }
}

class MileageInfoBox extends StatelessWidget {
  final _MileageTrackingAppState appState;
  final currentMileage = VehicleRepository.instance.currentVehicle.mileageTraveled;

  MileageInfoBox({super.key, 
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {

    final userController = Get.put(UserController());
    // Calculate mileage till now
    double mileageTillNow = appState.calculateMileageTraveledTillNow(
      appState.mileageWhenStarted,
      appState.mileageTillNow,
    );

    return Container(
      width: 380.0,
      height: 120.0,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 9, 118, 207),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 40.0, // Increase icon size
            ),
          ),
          const SizedBox(width: 32), // Space between icon and texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Make the column take up minimal space
              children: [
                const Text(
                  'You have gone :',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Text(
                    '${userController.vehicle.value.mileageTraveled} Km',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

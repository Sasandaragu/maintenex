import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/fuelTracking/screens/fuel_display.dart';
import 'package:maintenex/Features/fuelTracking/screens/fuel_form.dart';
import 'package:maintenex/Features/maintenance/screens/Records_description_screen.dart';
import 'package:maintenex/Features/maintenance/screens/part_replacement_records_form_screen.dart';
import 'package:maintenex/Features/maintenance/screens/part_replacement_records_screen.dart';
import 'package:maintenex/Features/maintenance/screens/repair_records_form_screen.dart';
import 'package:maintenex/Features/maintenance/screens/repair_records_screen.dart';
import 'package:maintenex/Features/maintenance/screens/service_records_form_screen.dart';
import 'package:maintenex/Features/maintenance/screens/service_records_screen.dart';
import 'package:maintenex/Features/mileage/Screens/addMileage.dart';
import 'package:maintenex/Features/personalization/controllers/user_controller.dart';
import 'package:maintenex/Features/report/screens/report_list.dart';
import 'package:maintenex/Features/report/screens/report_screen.dart';
import 'package:maintenex/Features/supportDesk/screens/chatbot.dart';
import 'package:maintenex/Features/vehicle/screens/vehicle_form.dart';
import 'package:maintenex/Features/vehicle/screens/vehicle_list.dart';
import 'package:maintenex/common/widgets/ad_slider.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/data/repositories/maintenex/service_record/serviceRecordRepository.dart';
import 'package:maintenex/features/aboutUs/screens/aboutus_screen.dart';
import 'package:maintenex/features/documents/screens/viewDocuments_screen.dart';
import 'package:maintenex/features/mileage/Screens/mileageScreens.dart';
import 'package:maintenex/features/reminders/screens/reminders_screen.dart';
import '../../../common/widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, this.title = 'Welcome to the Maintenex'})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedVehicle;
  ServiceRecordRepository serviceRep = ServiceRecordRepository();
  int serviceRecordCount = 0;

  fetchServiceRecordCount() async {
    serviceRecordCount = await serviceRep.getServiceRecordCount();
  }

  Widget _buildFeatureCard(
      String title, IconData icon, int count, BuildContext context) {
    String itemCountText = '$count Records'; // Default text

    if (title == 'Reminders') {
      itemCountText = '$count Reminders';
    }

    return InkWell(
      onTap: () {
        switch (title) {
          case 'Maintenence\n       Record':
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExplanationScreen()));
            break;
          case 'Reminders':
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ReminderScreen()));
            break;

          case 'Document':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ViewDocuments()));
            break;

          case 'Monthly Reports':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ReportsListScreen()));
            break;

          case 'Mileage':
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MileageTrackingApp()));
            break;

          case 'Fuel':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const FuelScreen()));
            break;
        }
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color.fromARGB(255, 21, 68, 103),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'New Repair':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => RepairRecordForm()));
            break;

          case 'New Service':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ServiceRecordForm()));
            break;

          case 'New Part Replacement':
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PartReplacementRecordForm()));
            break;

          case 'Update Mileage':
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AddMileageScreen(
                      onMileageAdded: (MileageEntry) {},
                    )));
            break;

          case 'Profile':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const FuelScreen()));
            break;

          case 'Documents':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ViewDocuments()));
            break;

          case 'Blutooth':
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ServiceRecordsScreen()));
            break;

          case 'Ask Help':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ChatScreen()));
            break;

          case 'Update Fuel':
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => FuelEntryForm()));
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color.fromARGB(255, 21, 68, 103),
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MHomeAppBar(), // Your custom AppBar-like widget
            const SizedBox(height: 20),
            // const AdSlider(),
            //const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => Get.to(() => VehiclesScreen(
                          userId: AuthenticationRepository.instance.authUser!.uid)),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        side: const BorderSide(width: 2.0, color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            const Text(
                              'Select a Vehicle -',
                              style: TextStyle(fontSize: 16.0),
                            ), // First piece of text
                            const SizedBox(
                              width: 0.0,
                            ), // Space between the texts
                            Obx(() => Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    controller.vehicle.value.vehicleNo.isEmpty
                                        ? " No Vehicle"
                                        : " ${controller.vehicle.value.vehicleNo}",
                                    style: const TextStyle(
                                        fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                )), // Second piece of text (vehicle number)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        // Navigate to the vehicle form screen when the plus icon is pressed
                        Get.to(() => const VehicleScreen());
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 36.0),
                    ),
                  ],
                ),
              ),
            ),




            const SizedBox(height: 30),
            const AdSlider(),

            /* Container(
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
                      mainAxisSize: MainAxisSize
                          .min, // Make the column take up minimal space
                      children: [
                        const Text(
                          'You have gone :',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${currentMileage} Km',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _buildQuickActionButton('New Repair', Icons.build, context),
                  _buildQuickActionButton(
                      'New Service', Icons.local_car_wash, context),
                  _buildQuickActionButton(
                      'New Part Replacement', Icons.build_circle, context),
                  _buildQuickActionButton(
                      'Update Mileage', Icons.speed, context),
                  _buildQuickActionButton(
                      'Update Fuel', Icons.local_gas_station, context),
                  _buildQuickActionButton('Ask Help', Icons.help, context),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.only(
                  top: 10.0), // Adjust the top padding as needed
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Features',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _buildFeatureCard(
                      'Maintenence\n       Record', Icons.build, 5, context),
                  _buildFeatureCard('Reminders', Icons.alarm, 8, context),
                  _buildFeatureCard('Document', Icons.description, 12, context),
                  _buildFeatureCard(
                      'Monthly Reports', Icons.insert_drive_file, 12, context),
                  _buildFeatureCard(
                      'Mileage', Icons.directions_car, 12, context),
                  _buildFeatureCard(
                      'Fuel', Icons.local_gas_station, 12, context),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Quick Actions Grid
          ],
        ),
      ),
    );
  }

}

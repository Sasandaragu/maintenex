import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/personalization/controllers/user_controller.dart';
import 'package:maintenex/Features/vehicle/models/vehicle_model.dart';
import 'package:maintenex/Features/vehicle/screens/vehicle_form.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehiclesScreen extends StatefulWidget {
  final String userId;

  const VehiclesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _VehiclesScreenState createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  late VehicleRepository vehicleRepository;
  VehicleModel? selectedVehicle;

  @override
  void initState() {
    super.initState();
    vehicleRepository = VehicleRepository();
  }

  Future<void> saveSelectedVehicleId(String id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('selectedVehicleId', id);
}

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Vehicle'),
      ),
      body: FutureBuilder<List<VehicleModel>>(
        future: vehicleRepository.fetchVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final vehicles = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: 
                  ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      final bool isSelected = selectedVehicle?.vehicleNo == vehicle.vehicleNo;
                      return Card(
                        color: isSelected ? Colors.green[100] : null,
                        child: ListTile(
                          title: Text(vehicle.vehicleNickname),
                          subtitle: Text('${vehicle.vehicleNo}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(isSelected ? Icons.check_circle : Icons.check_circle_outline),
                                onPressed: () => setState(() {
                                  selectedVehicle = vehicle;
                                  saveSelectedVehicleId(vehicle.vehicleNo);
                                  UserController.instance.fetchVehicleRecord();
                                }),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  // Add confirmation dialog before deleting
                                  bool confirm = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Vehicle'),
                                      content: Text('Are you sure you want to delete this vehicle?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm ?? false) {
                                    VehicleRepository.instance.deleteVehicleRecord(vehicle.vehicleNo);
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () => setState(() {
                            selectedVehicle = vehicle;
                            saveSelectedVehicleId(vehicle.vehicleNo);
                            UserController.instance.fetchVehicleRecord();
                          }),
                        ),
                      );
                    },
                  ),

                ),
                const Divider(),
                  Text(
                      "Vehicles Added",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          child: const Text('Add New Vehicle'),
                          onPressed: () => Get.to(() => VehicleScreen())),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: Text('No vehicles found'));
          }
        },
      ),
    );
  }

}

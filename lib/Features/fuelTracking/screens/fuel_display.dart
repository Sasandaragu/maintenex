import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import 'fuel_chart.dart';
import 'fuel_form.dart';


class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});

  @override
  _FuelScreenState createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  String userID = AuthenticationRepository.instance.authUser!.uid;
  String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Monthly Fuel Usage",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: FuelUsageChart(userId: userID),
            ),
          ),
          Text(
            "Fuel Records of $vehicleNo",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Add New Record'),
                onPressed: () => Get.to(() => FuelEntryForm()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

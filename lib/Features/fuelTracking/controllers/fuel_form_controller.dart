import 'package:get/get.dart';

import '../../../data/repositories/fuel/fuel_repository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/poppups/loaders.dart';
import '../models/fuel_record_model.dart';
import '../screens/fuel_display.dart';


class FuelController {
  final VehicleRepository vehicleRepository = VehicleRepository();
  String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
  final FuelRepository fuelRepository = FuelRepository();

  Future<void> addFuelRecord({required double amount}) async {
    try {
      MLoaders.customToast(message: 'Proccessing...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw "Network error";
      }

      final newFuelRecord = FuelRecordModel(
        amount: amount,
      );

      await fuelRepository.addFuelRecord(newFuelRecord);

      MLoaders.successSnackBar(
          title: 'Success', message: 'Fuel has been Updated');

      Get.to(() => FuelScreen());
    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}

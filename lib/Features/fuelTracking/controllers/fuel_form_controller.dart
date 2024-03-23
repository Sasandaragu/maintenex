import 'package:get/get.dart';
import 'package:maintenex/Features/fuelTracking/models/fuel_record_model.dart';
import 'package:maintenex/Features/fuelTracking/screens/fuel_display.dart';
import 'package:maintenex/data/repositories/fuel/fuel_repository.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';
import 'package:maintenex/utils/helpers/network_manager.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

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

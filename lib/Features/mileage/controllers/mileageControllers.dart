import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/mileage/mileage_repository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/poppups/loaders.dart';
import '../../personalization/controllers/user_controller.dart';
import '../Screens/mileageScreens.dart';
import '../models/mileageModels.dart';
import '../models/mileage_record_model.dart';

class MileageController {
  final List<MileageEntry> _mileages = [];
  final VehicleRepository vehicleRepository = VehicleRepository();
  final MileageRepository mileageRepository = MileageRepository();

  double currentMileage = 0.0;

  List<MileageEntry> get mileages => List.unmodifiable([..._mileages]);
  String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;

  double addMileage(MileageEntry mileageEntry) {
    currentMileage = mileageEntry.mileage;
    _mileages.add(mileageEntry);
    return currentMileage;
  }

  Future<void> updateNewMileage({
    required double newMileage
  }) async {

    try {
      MLoaders.customToast(message: 'Proccessing...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw "Network error";
      }

      String userID = AuthenticationRepository.instance.authUser!.uid;
      double mileageTravelled = await VehicleRepository.instance.fetchMileageTravelled(userID, vehicleNo);
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final newMileageRecord = MileageRecordModel(
        date: currentDate, 
        preMileage: mileageTravelled, 
        newMileage: newMileage, 
        difference: newMileage - mileageTravelled
      );

      if (newMileage<mileageTravelled) {
        throw "Invalid Mileage Entered";
      }

      await mileageRepository.addMileageRecord(newMileageRecord);

      await vehicleRepository.updateMileageTraveled(vehicleNo, newMileage);

      MLoaders.successSnackBar(
          title: 'Success', message: 'Mileage has been Updated');

      UserController.instance.fetchVehicleRecord();
      
      Get.to(() => const MileageTrackingApp());

    } catch (e) {
      MLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}

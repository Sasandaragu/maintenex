import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/poppups/loaders.dart';
import '../../Home/screens/home_screens.dart';
import '../../personalization/controllers/user_controller.dart';
import '../models/vehicle_model.dart';

class VehicleController extends GetxController{
  static VehicleController get instance => Get.find();

    final vehicleNo = TextEditingController();
    final vehicleType = TextEditingController();
    final vehicleBrand = TextEditingController();
    final vehicleNickname = TextEditingController();
    final mileageTraveled = TextEditingController();
    final userID = AuthenticationRepository.instance.authUser!.uid;
    GlobalKey<FormState> vehicleFormKey = GlobalKey<FormState>();


    void addVehicle() async {
      try {
        MLoaders.customToast(message: 'Proccessing...');

        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          throw "Network error";
        }

        if (!vehicleFormKey.currentState!.validate()) {
          throw "Form Key Error";
        }

        final newVehicle = VehicleModel(
          vehicleNo: vehicleNo.text.trim(), 
          vehicleType: vehicleType.text.trim(), 
          vehicleNickname: vehicleNickname.text.trim(), 
          mileageTraveled: double.parse(mileageTraveled.text.trim()), 
          userID: userID,
          vehicleBrand: vehicleBrand.text.trim(),
        );

        final vehicleRepository = Get.put(VehicleRepository());
        await vehicleRepository.saveVehicleRecord(newVehicle);
        
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('selectedVehicleId', newVehicle.vehicleNo);
        UserController.instance.fetchVehicleRecord();

        MLoaders.successSnackBar(title: 'Success', message: 'Your Vehicle has been Added');
        Get.to(() => const HomeScreen());

      } catch (e) {
        MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
      }
    }
}
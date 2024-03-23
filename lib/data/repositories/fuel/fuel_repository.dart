import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:maintenex/Features/fuelTracking/models/fuel_record_model.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';

class FuelRepository extends GetxController{
  static FuelRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userID = AuthenticationRepository.instance.authUser!.uid;
  final vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;

  Future<void> addFuelRecord(FuelRecordModel fuelRecord) async {
    await _firestore.collection("Users").doc(userID).collection("Vehicle").doc(vehicleNo).collection("FuelRecords").add(fuelRecord.toMap());
  }
}
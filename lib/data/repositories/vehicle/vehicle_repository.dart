import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../Features/vehicle/models/vehicle_model.dart';
import '../../../Features/Home/screens/home_screens.dart';
import '../../../../Features/reminders/models/milestone_model.dart';
import '../../../Features/reminders/screens/local_notifications.dart';
import '../authentication/authentication_repository.dart';

class VehicleRepository extends GetxController {
  static VehicleRepository get instance => Get.find();

  VehicleModel currentVehicle = VehicleModel.empty();

  VehicleModel? get vehicle => currentVehicle;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveVehicleRecord(VehicleModel vehicle) async {
    try {
      await _db
          .collection("Users")
          .doc(vehicle.userID)
          .collection("Vehicle")
          .doc(vehicle.vehicleNo)
          .set(vehicle.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VehicleModel>> fetchVehicles() async {
    try {
      String userID = AuthenticationRepository.instance.authUser!.uid;
      var vehiclesCollection = _db.collection('Users/$userID/Vehicle');
      var snapshot = await vehiclesCollection.get();
      return snapshot.docs
          .map((doc) => VehicleModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching vehicles: $e');
    }
  }

  Future<String?> loadSelectedVehicleId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedVehicleId');
  }

  Future<VehicleModel> fetchVehicleDetails() async {
    try {
      String vehicleNo = await loadSelectedVehicleId() as String;
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .collection("Vehicle")
          .doc(vehicleNo)
          .get();
      if (documentSnapshot.exists) {
        currentVehicle = VehicleModel.fromSnapshot(documentSnapshot);
        return currentVehicle;
      } else {
        return VehicleModel.empty();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMileageTraveled(
      String vehicleNo, double newMileage) async {
    try {
      String userID = AuthenticationRepository.instance.authUser!.uid;
      DocumentReference vehicleRef = _db
          .collection("Users")
          .doc(userID)
          .collection("Vehicle")
          .doc(vehicleNo);

      DocumentSnapshot vehicleSnapshot = await vehicleRef.get();
      if (vehicleSnapshot.exists) {
        Map<String, dynamic> data =
            vehicleSnapshot.data() as Map<String, dynamic>;

        data['mileageTraveled'] = newMileage;

        await vehicleRef.update(data);
      } else {
        throw Exception('Vehicle not found.');
      }
      //Checking for upcoming reminders 
       await checkRemindersAndNotify(userID, vehicleNo, newMileage);
    } catch (e) {
      rethrow;
    }
  }
   Future<void> checkRemindersAndNotify(String userID, String vehicleNo, double mileageTravelled) async {
  try {
    var remindersSnapshot = await _db
        .collection("Users")
        .doc(userID)
        .collection("Vehicle")
        .doc(vehicleNo)
        .collection("MileStones")
        .get();

    List<MileStoneModel> remindersToNotify = [];

    for (var doc in remindersSnapshot.docs) {
      MileStoneModel reminder = MileStoneModel.fromMap(doc.data());

      // Check if the current mileage of the vehicle is getting closer to any reminder's alert mileage
      //add those reminders to the list of notifications
      if (((reminder.alertMileage-100) <= mileageTravelled) && !(mileageTravelled > reminder.alertMileage + 1000 )) {
        remindersToNotify.add(reminder);
        
      }
    }

    // Create notifications for all reminders in the list
    LocalNotifications.showSimpleNotifications(remindersToNotify);
    } catch (e) {
    rethrow;
    }
  }


  Future<double> fetchMileageTravelled(String userId, String vehicleNo) async {
    try {
      DocumentSnapshot vehicleSnapshot = await _db
          .collection('Users')
          .doc(userId)
          .collection('Vehicle')
          .doc(vehicleNo)
          .get();

      if (vehicleSnapshot.exists) {
        Map<String, dynamic> vehicleData = vehicleSnapshot.data() as Map<String, dynamic>;
        return vehicleData['mileageTraveled']?.toDouble() ?? 0.0;
      } else {
        throw Exception('Vehicle document does not exist');
      }
    } catch (e) {
      // Handle errors or exceptions as needed
      throw Exception('Error fetching mileage travelled: $e');
    }
  }

  Future<void> deleteVehicleRecord(String vehicleNo) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    try {
      await _db
          .collection("Users")
          .doc(userID)
          .collection("Vehicle")
          .doc(vehicleNo)
          .delete();
      
      removeSelectedVehicleId();
      Get.to(() => const HomeScreen());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeSelectedVehicleId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedVehicleId');
  }
}

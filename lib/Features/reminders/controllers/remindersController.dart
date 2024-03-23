import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';
import 'package:maintenex/features/reminders/models/milestone_model.dart';

class ReminderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var milestones = <MileStoneModel>[].obs;

 //Method to retrieve all the part replacement reminders from the colection
  Future<List<MileStoneModel>> fetchMilestones() async {
  try {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;

    var remindersCollection = _firestore
        .collection("Users")
        .doc(userID)
        .collection("Vehicle")
        .doc(vehicleNo)
        .collection("MileStones");

    var snapshot = await remindersCollection.get();

    return snapshot.docs
        .map((doc) => MileStoneModel.fromMap(doc.data()))
        .toList();
      } catch (e) {
    // Handle errors or exceptions as needed
    throw Exception('Error fetching local reminders: $e');
    }
  }

  Future<void> togglePartReplacementAlert(String documentId, bool isEnabled) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;

    await _firestore
      .collection("Users")
      .doc(userID)
      .collection("Vehicle")
      .doc(vehicleNo)
      .collection('PartReplacementRecords')
      .doc(documentId)
      .update({"enableAlert": isEnabled});
  }

  Future<void> toggleServiceRecordAlert(String documentId, bool isEnabled) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;

    await _firestore
      .collection("Users")
      .doc(userID)
      .collection("Vehicle")
      .doc(vehicleNo)
      .collection('ServiceRecords')
      .doc(documentId)
      .update({"enableAlert": isEnabled});
  }
  
  // Modify this method to determine whether to call togglePartReplacementAlert or toggleServiceRecordAlert
  Future<void> toggleReminderAlert(String documentId, bool isEnabled, String recordType) async {
    if (recordType == 'Part Replacement Record') {
      await togglePartReplacementAlert(documentId, isEnabled);
    } else if (recordType == 'Service Record') {
      await toggleServiceRecordAlert(documentId, isEnabled);
    }
  }
  
  
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maintenex/Features/mileage/models/mileage_record_model.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';

class MileageRepository extends GetxController{
  static MileageRepository get instance => Get.find();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userID = AuthenticationRepository.instance.authUser!.uid;
  final vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;

  MileageRecordModel currentMileage = MileageRecordModel.empty();

  Future<void> addMileageRecord(MileageRecordModel mileageRecord) async {
    await _firestore.collection("Users").doc(userID).collection("Vehicle").doc(vehicleNo).collection("MileageRecords").add(mileageRecord.toMap());
  }

  Future<List<MileageRecordModel>> fetchMileageRecords() async {
    try {
      var mileageRecordCollection = _firestore.collection('Users/$userID/Vehicle/$vehicleNo/MileageRecords');
      var snapshot = await mileageRecordCollection.get();
      return snapshot.docs
          .map((doc) => MileageRecordModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // Handle errors or exceptions as needed
      throw Exception('Error fetching Mileage Records: $e');
    }
  }

  Future<List<MileageRecordModel>> fetchMileageRecordsForMonth(int year, int month) async {

    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 0); // 0 means the last day of the month

    String startString = DateFormat('yyyy-MM-dd').format(startDate);
    String endString = DateFormat('yyyy-MM-dd').format(endDate);

    QuerySnapshot querySnapshot = await _firestore
        .collection('Users')
        .doc(userID)
        .collection('Vehicle')
        .doc(vehicleNo)
        .collection('MileageRecords')
        .where('date', isGreaterThanOrEqualTo: startString)
        .where('date', isLessThanOrEqualTo: endString)
        .get();

    List<MileageRecordModel> records = querySnapshot.docs
        .map((doc) => MileageRecordModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return records;
  }   
}
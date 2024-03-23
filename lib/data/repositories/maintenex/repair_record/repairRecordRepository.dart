import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:maintenex/Features/maintenance/models/repair_record/repair_record_model.dart';
import 'package:maintenex/data/repositories/authentication/authentication_repository.dart';
import 'package:maintenex/data/repositories/vehicle/vehicle_repository.dart';
import 'package:path/path.dart' as Path;

class RepairRecordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addRepairRecord(
      RepairRecordModel repairRecord, List<PlatformFile>? files) async {
    // First, add the Repair record data to Firestore without the file URLs
    DocumentReference docRef = await _firestore
        .collection("Users")
        .doc(AuthenticationRepository.instance.authUser?.uid)
        .collection("Vehicle")
        .doc(VehicleRepository.instance.currentVehicle.vehicleNo)
        .collection('RepairRecords')
        .add(repairRecord.toMap());

    List<String> fileUrls = [];

    // Check if there are files to upload
    if (files != null && files.isNotEmpty) {
      for (PlatformFile file in files) {
        String fileUrl = await uploadFile(file, docRef.id);
        fileUrls.add(fileUrl);
      }
      await docRef.update({'fileUrls': fileUrls});
    }
  }

  Future<String> uploadFile(PlatformFile file, String docId) async {
    String fileName = Path.basename(file.name);
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    String filePath = '$userID/$vehicleNo/RepairRecords/$docId/$fileName';
    Reference ref = _storage.ref().child(filePath);
    File fileOnDevice = File(file.path!);
    UploadTask uploadTask = ref.putFile(fileOnDevice);
    await uploadTask;
    String fileUrl = await ref.getDownloadURL();
    return fileUrl;
  }

  Future<List<RepairRecordModel>> fetchRepairRecords() async {
    try {
      String userID = AuthenticationRepository.instance.authUser!.uid;
      String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
      var RepairRecordCollection = _firestore
          .collection('Users/$userID/Vehicle/$vehicleNo/RepairRecords');
      var snapshot = await RepairRecordCollection.get();
      return snapshot.docs
          .map((doc) => RepairRecordModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // Handle errors or exceptions as needed
      throw Exception('Error fetching Repair Records: $e');
    }
  }

  Future<int> getRepairRecordCount() async {
    try {
      String userID = AuthenticationRepository.instance.authUser!.uid;
      String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
      var repairRecordCollection = _firestore
          .collection('Users/$userID/Vehicle/$vehicleNo/RepairRecords');
      var snapshot = await repairRecordCollection.get();
      return snapshot.docs.length; // The count of documents in the collection
    } catch (e) {
      return 0; // Return 0 or handle the error as appropriate
    }
  }

  Future<List<RepairRecordModel>> fetchRepairRecordsForMonth(
      int year, int month) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate =
        DateTime(year, month + 1, 0); // 0 means the last day of the month

    String startString = DateFormat('yyyy-MM-dd').format(startDate);
    String endString = DateFormat('yyyy-MM-dd').format(endDate);

    QuerySnapshot querySnapshot = await _firestore
        .collection('Users')
        .doc(userID)
        .collection('Vehicle')
        .doc(vehicleNo)
        .collection('RepairRecords')
        .where('date', isGreaterThanOrEqualTo: startString)
        .where('date', isLessThanOrEqualTo: endString)
        .get();

    List<RepairRecordModel> records = querySnapshot.docs
        .map((doc) =>
            RepairRecordModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return records;
  }

  Future<void> deleteRepairRecord(
      {required RepairRecordModel repairRecord}) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("Users")
          .doc(userID)
          .collection("Vehicle")
          .doc(vehicleNo)
          .collection('repairRecord')
          .where('serviceProvider',
              isEqualTo: repairRecord.serviceProvider.trim())
          .where('date', isEqualTo: repairRecord.date.trim())
          .where('totalCost', isEqualTo: repairRecord.totalCost)
          .where('description', isEqualTo: repairRecord.description.trim())
          //.where('fileUrls', isEqualTo: serviceRecord.fileUrls)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming there is only one document with matching details
        DocumentSnapshot doc = snapshot.docs.first;

        await doc.reference.delete();
      } else {
        throw Exception('No matching service record found');
      }
    } catch (e) {
      throw Exception('Error deleting service record: $e');
    }
  }

  Future<void> deleteMileStone(String maintenanceId) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection("Users")
          .doc(userID)
          .collection("Vehicle")
          .doc(vehicleNo)
          .collection("MileStones")
          .where("maintenanceId", isEqualTo: maintenanceId)
          .get();

      final List<DocumentSnapshot> documents = querySnapshot.docs;

      for (DocumentSnapshot doc in documents) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw ("Error deleting mile stones: $e");
    }
  }
}

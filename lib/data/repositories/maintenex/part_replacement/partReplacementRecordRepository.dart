import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as Path;

import '../../../../Features/maintenance/models/part_replacement_record/part_raplacement_record_model.dart';
import '../../../../Features/reminders/models/milestone_model.dart';
import '../../authentication/authentication_repository.dart';
import '../../vehicle/vehicle_repository.dart';

class PartReplacementRecordRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addPartReplacementRecord(
      PartReplacementRecordModel partReplacementRecord,
      List<PlatformFile>? files) async {
    // First, add the service record data to Firestore without the file URLs
    DocumentReference docRef = await _firestore
        .collection("Users")
        .doc(AuthenticationRepository.instance.authUser?.uid)
        .collection("Vehicle")
        .doc(VehicleRepository.instance.currentVehicle.vehicleNo)
        .collection('PartReplacementRecords')
        .add(partReplacementRecord.toMap());

    List<String> fileUrls = [];

    // Check if there are files to upload
    if (files != null && files.isNotEmpty) {
      for (PlatformFile file in files) {
        String fileUrl = await uploadFile(file, docRef.id);
        fileUrls.add(fileUrl);
      }
      await docRef.update({'fileUrls': fileUrls});
    }

    if (partReplacementRecord.enableAlert) {
      String userID = AuthenticationRepository.instance.authUser!.uid;
      String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
      double mileageTravelled = await VehicleRepository.instance
          .fetchMileageTravelled(userID, vehicleNo);

      final newMileStone = MileStoneModel(
          maintenanceId: docRef.id,
          title:
              'Part replacement Alert - ${partReplacementRecord.replacedPart}',
          alertMileage:
              mileageTravelled + partReplacementRecord.recommendedMileage,
          recordType: 'Part Replacement Record',
          date: partReplacementRecord.date);

      await _firestore
          .collection("Users")
          .doc(userID)
          .collection("Vehicle")
          .doc(vehicleNo)
          .collection("MileStones")
          .add(newMileStone.toMap());
    }
  }

  Future<String> uploadFile(PlatformFile file, String docId) async {
    String fileName = Path.basename(file.name);
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    String filePath =
        '$userID/$vehicleNo/PartReplacementRecords/$docId/$fileName';
    Reference ref = _storage.ref().child(filePath);
    File fileOnDevice = File(file.path!);
    UploadTask uploadTask = ref.putFile(fileOnDevice);
    await uploadTask;
    String fileUrl = await ref.getDownloadURL();
    return fileUrl;
  }

  Future<List<PartReplacementRecordModel>> fetchPartReplacementRecords() async {
    try {
      String userID = AuthenticationRepository.instance.authUser!.uid;
      String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
      var partReplacementRecordCollection = _firestore.collection(
          'Users/$userID/Vehicle/$vehicleNo/PartReplacementRecords');
      var snapshot = await partReplacementRecordCollection.get();
      return snapshot.docs
          .map((doc) => PartReplacementRecordModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // Handle errors or exceptions as needed
      throw Exception('Error fetching Part Replacement Records: $e');
    }
  }

  Future<List<PartReplacementRecordModel>> fetchRelevantPartReplacementRecord() async {
    try {
      String userID = AuthenticationRepository.instance.authUser!.uid;
      String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
      var partReplacementRecordCollection = _firestore.collection('Users/$userID/Vehicle/$vehicleNo/PartReplacementRecords');
      var snapshot = await partReplacementRecordCollection.where('enableAlert', isEqualTo: true).get();
      return snapshot.docs
          .map((doc) => PartReplacementRecordModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // Handle errors or exceptions as needed
      throw Exception('Error fetching Part Replacement Records: $e');
    }
  }

  Future<List<PartReplacementRecordModel>> fetchPartReplacementRecordsForMonth(int year, int month) async {
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
        .collection('PartReplacementRecords')
        .where('date', isGreaterThanOrEqualTo: startString)
        .where('date', isLessThanOrEqualTo: endString)
        .get();

    List<PartReplacementRecordModel> records = querySnapshot.docs
        .map((doc) => PartReplacementRecordModel.fromMap(
            doc.data() as Map<String, dynamic>))
        .toList();

    return records;
  }

  Future<void> deletePartReplacementRecord(
      {required PartReplacementRecordModel partReplacementRecord}) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("Users")
          .doc(userID)
          .collection("Vehicle")
          .doc(vehicleNo)
          .collection('PartReplacementRecords')
          .where('serviceProvider',
              isEqualTo: partReplacementRecord.serviceProvider.trim())
          .where('date', isEqualTo: partReplacementRecord.date.trim())
          .where('recommendedMileage',
              isEqualTo: partReplacementRecord.recommendedMileage)
          .where('recommendedLifetime',
              isEqualTo: partReplacementRecord.recommendedLifetime)
          .where('totalCost', isEqualTo: partReplacementRecord.totalCost)
          .where('description',
              isEqualTo: partReplacementRecord.description.trim())
          //.where('fileUrls', isEqualTo: serviceRecord.fileUrls)
          .where('enableAlert', isEqualTo: partReplacementRecord.enableAlert)
          .where('replacedPart', isEqualTo: partReplacementRecord.replacedPart)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming there is only one document with matching details
        DocumentSnapshot doc = snapshot.docs.first;

        if (partReplacementRecord.enableAlert) {
          deleteMileStone(doc.id);
        }
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

  Future<void> RemoveAlert(
      {required PartReplacementRecordModel partReplacementRecord}) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("Users")
          .doc(userID)
          .collection("Vehicle")
          .doc(vehicleNo)
          .collection('PartReplacementRecords')
          .where('serviceProvider',
              isEqualTo: partReplacementRecord.serviceProvider.trim())
          .where('date', isEqualTo: partReplacementRecord.date.trim())
          .where('recommendedMileage',
              isEqualTo: partReplacementRecord.recommendedMileage)
          .where('recommendedLifetime',
              isEqualTo: partReplacementRecord.recommendedLifetime)
          .where('totalCost', isEqualTo: partReplacementRecord.totalCost)
          .where('description',
              isEqualTo: partReplacementRecord.description.trim())
          //.where('fileUrls', isEqualTo: serviceRecord.fileUrls)
          .where('enableAlert', isEqualTo: partReplacementRecord.enableAlert)
          .where('replacedPart', isEqualTo: partReplacementRecord.replacedPart)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming there is only one document with matching details
        DocumentSnapshot doc = snapshot.docs.first;

        if (partReplacementRecord.enableAlert) {
          deleteMileStone(doc.id);
        }
      } else {
        throw Exception('No matching service record found');
      }
    } catch (e) {
      throw Exception('No matching service record found: $e');
    }
  }
}

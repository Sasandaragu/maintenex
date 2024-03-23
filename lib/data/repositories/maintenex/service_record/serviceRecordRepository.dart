import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as Path;

import '../../../../Features/maintenance/models/service_record/service_record_model.dart';
import '../../../../Features/reminders/models/milestone_model.dart';
import '../../authentication/authentication_repository.dart';
import '../../vehicle/vehicle_repository.dart';

//class ServiceRecordRepository{

// class ServiceRecordRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<void> addServiceRecord(Map<String, dynamic> serviceRecordData, List<PlatformFile>? files) async {
//     // Add service record data to Firestore
//     DocumentReference docRef = await _firestore
      // .collection("Users")
      // .doc(AuthenticationRepository.instance.authUser?.uid)
      // .collection("Vehicle")
      // .doc(VehicleRepository.instance.currentVehicle.vehicleNo)
      // .collection('ServiceRecords').add(serviceRecordData);

//     List<String> fileUrls = [];

//     if (files != null && files.isNotEmpty) {
//       // Upload files to Firebase Storage
//       for (PlatformFile file in files) {
//         String fileUrl = await uploadFile(file, docRef.id);
//         fileUrls.add(fileUrl);
//       }
//       // Update the document with the file URLs if files were uploaded
//       await docRef.update({'fileUrls': fileUrls});
//     }
//   }

//   Future<String> uploadFile(PlatformFile file, String docId) async {
//     String fileName = Path.basename(file.name);
//     String? userID = AuthenticationRepository.instance.authUser?.uid;
//     String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
//     String filePath = '$userID/$vehicleNo/"ServiceRecordDocs"/$docId/$fileName';
//     Reference ref = _storage.ref().child(filePath);
//     UploadTask uploadTask = ref.putData(file.bytes!);
//     await uploadTask;
//     String fileUrl = await ref.getDownloadURL();
//     return fileUrl;
//   }
// }

class ServiceRecordRepository extends GetxController{

  static ServiceRecordRepository get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addServiceRecord(ServiceRecordModel serviceRecord, List<PlatformFile>? files) async {
    // First, add the service record data to Firestore without the file URLs
    DocumentReference docRef = await _firestore
    .collection("Users")
    .doc(AuthenticationRepository.instance.authUser?.uid)
    .collection("Vehicle")
    .doc(VehicleRepository.instance.currentVehicle.vehicleNo)
    .collection('ServiceRecords')
    .add(serviceRecord.toMap());

    List<String> fileUrls = [];

    // Check if there are files to upload
    if (files != null && files.isNotEmpty) {
      for (PlatformFile file in files) {
        String fileUrl = await uploadFile(file, docRef.id);
        fileUrls.add(fileUrl);
      }
      await docRef.update({'fileUrls': fileUrls});
    }

    if (serviceRecord.enableAlert) { 
      String userID = AuthenticationRepository.instance.authUser!.uid;
      String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
      double mileageTravelled = await VehicleRepository.instance.fetchMileageTravelled(userID, vehicleNo);

      // Check if there is a previous milestone with recordType 'Service Record'
      QuerySnapshot<Map<String, dynamic>> milestoneQuery = await _firestore
        .collection("Users")
        .doc(userID)
        .collection("Vehicle")
        .doc(vehicleNo)
        .collection("MileStones")
        .where('recordType', isEqualTo: 'Service Record')
        .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> milestoneDoc in milestoneQuery.docs) {
        await milestoneDoc.reference.delete();
      }

      final newMileStone = MileStoneModel(
        maintenanceId: docRef.id, 
        title: 'Service Alert', 
        alertMileage: mileageTravelled + serviceRecord.recommendedMileage,
        recordType: 'Service Record', 
        date: serviceRecord.date
      );

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
    String filePath = '$userID/$vehicleNo/ServiceRecords/$docId/$fileName';
    Reference ref = _storage.ref().child(filePath);
    File fileOnDevice = File(file.path!);
    UploadTask uploadTask = ref.putFile(fileOnDevice);
    await uploadTask;
    String fileUrl = await ref.getDownloadURL();
    return fileUrl;
  }

  Future<List<ServiceRecordModel>> fetchServiceRecords() async {
    try {
      String userID = AuthenticationRepository.instance.authUser!.uid;
      String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
      var serviceRecordCollection = _firestore.collection('Users/$userID/Vehicle/$vehicleNo/ServiceRecords');
      var snapshot = await serviceRecordCollection.get();
      return snapshot.docs
          .map((doc) => ServiceRecordModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // Handle errors or exceptions as needed
      throw Exception('Error fetching Service Records: $e');
    }
  }

  Future<List<ServiceRecordModel>> fetchRelevantServiceRecords() async {
  try {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    var serviceRecordCollection = _firestore.collection('Users/$userID/Vehicle/$vehicleNo/ServiceRecords');
    
    var snapshot = await serviceRecordCollection
        .where('enableAlert', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => ServiceRecordModel.fromMap(doc.data()))
        .toList();
  } catch (e) {
    // Handle errors or exceptions as needed
    throw Exception('Error fetching Service Records: $e');
  }
}


  Future<int> getServiceRecordCount() async {
    try {
      String userID = AuthenticationRepository.instance.authUser!.uid;
      String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
      var serviceRecordCollection = _firestore.collection('Users/$userID/Vehicle/$vehicleNo/ServiceRecords');
      var snapshot = await serviceRecordCollection.get();
      return snapshot.docs.length; // The count of documents in the collection
    } catch (e) {
      return 0; // Return 0 or handle the error as appropriate
    }
  }

  Future<List<ServiceRecordModel>> fetchServiceRecordsForMonth(int year, int month) async {

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
        .collection('ServiceRecords')
        .where('date', isGreaterThanOrEqualTo: startString)
        .where('date', isLessThanOrEqualTo: endString)
        .get();

    List<ServiceRecordModel> records = querySnapshot.docs
        .map((doc) => ServiceRecordModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return records;
  }

  Future<void> deleteServiceRecord({
    required ServiceRecordModel serviceRecord
  }) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("Users")
          .doc(userID)
          .collection("Vehicle")
          .doc(vehicleNo)
          .collection('ServiceRecords')
          .where('serviceProvider', isEqualTo: serviceRecord.serviceProvider.trim())
          .where('date', isEqualTo: serviceRecord.date.trim())
          .where('recommendedMileage', isEqualTo: serviceRecord.recommendedMileage)
          .where('recommendedLifetime', isEqualTo: serviceRecord.recommendedLifetime)
          .where('totalCost', isEqualTo: serviceRecord.totalCost)
          .where('description', isEqualTo: serviceRecord.description.trim())
          //.where('fileUrls', isEqualTo: serviceRecord.fileUrls)
          .where('enableAlert', isEqualTo: serviceRecord.enableAlert)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming there is only one document with matching details
        DocumentSnapshot doc = snapshot.docs.first;

        if (serviceRecord.enableAlert) {
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
      throw("Error deleting mile stones: $e");
    }
  }

  Future<void> RemoveAlert({
    required ServiceRecordModel serviceRecord
  }) async {
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("Users")
          .doc(userID)
          .collection("Vehicle")
          .doc(vehicleNo)
          .collection('ServiceRecords')
          .where('serviceProvider', isEqualTo: serviceRecord.serviceProvider.trim())
          .where('date', isEqualTo: serviceRecord.date.trim())
          .where('recommendedMileage', isEqualTo: serviceRecord.recommendedMileage)
          .where('recommendedLifetime', isEqualTo: serviceRecord.recommendedLifetime)
          .where('totalCost', isEqualTo: serviceRecord.totalCost)
          .where('description', isEqualTo: serviceRecord.description.trim())
          //.where('fileUrls', isEqualTo: serviceRecord.fileUrls)
          .where('enableAlert', isEqualTo: serviceRecord.enableAlert)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming there is only one document with matching details
        DocumentSnapshot doc = snapshot.docs.first;

        if (serviceRecord.enableAlert) {
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
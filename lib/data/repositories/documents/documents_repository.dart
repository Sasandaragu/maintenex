import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../Features/documents/models/document_model.dart';
import '../../../Features/reminders/screens/local_notifications.dart';

import '../authentication/authentication_repository.dart';
import '../vehicle/vehicle_repository.dart';

class DocumentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(PlatformFile file, String docId) async {
    String fileName = Path.basename(file.name);
    String userID = AuthenticationRepository.instance.authUser!.uid;
    String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
    String filePath = '$userID/$vehicleNo/Documents/$docId/$fileName';
    Reference ref = _storage.ref().child(filePath);
    File fileOnDevice = File(file.path!);
    UploadTask uploadTask = ref.putFile(fileOnDevice);
    await uploadTask;
    String fileUrl = await ref.getDownloadURL();
    return fileUrl;
  }
  Future<void> addDocumentRecord(VehicleDocument newDocument,List<PlatformFile>files) async{
    DocumentReference docRef = await _firestore
    .collection("Users")
    .doc(AuthenticationRepository.instance.authUser?.uid)
    .collection("Vehicle")
    .doc(VehicleRepository.instance.currentVehicle.vehicleNo)
    .collection('Documents')
    .add(newDocument.toMap());

     if (files.isNotEmpty) {

      String fileUrl = await uploadFile(files.first, docRef.id);
       await docRef.update({'fileUrl': fileUrl});

      LocalNotifications.scheduleDocumentExpiryNotification(newDocument);
      LocalNotifications.checkScheduledNotifications();
    }  
  }
 
  Future<List<VehicleDocument>> fetchVehicleDocuments() async {
    
    try {
      String userId = AuthenticationRepository.instance.authUser!.uid;
      String vehicleNo = VehicleRepository.instance.currentVehicle.vehicleNo;
      var collection = _firestore.collection('Users/$userId/Vehicle/$vehicleNo/Documents');
      var querySnapshot = await collection.get();
      return querySnapshot.docs
      .map((doc) => VehicleDocument.fromMap(doc.data()))
      .toList();

    } catch (e) {
      throw Exception('Error fetching Service Records: $e');
    }
  }
   
}

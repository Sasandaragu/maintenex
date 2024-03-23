import 'package:get/get.dart';
import 'package:maintenex/Features/Home/screens/home_screens.dart';
import 'package:maintenex/data/repositories/documents/documents_repository.dart';
import 'package:maintenex/features/documents/models/document_model.dart';
import 'package:maintenex/features/reminders/screens/local_notifications.dart';
import 'package:maintenex/utils/helpers/network_manager.dart';
import 'package:maintenex/utils/poppups/loaders.dart';

class DocumentUploadController{
  final DocumentRepository _docRepository = DocumentRepository();

  Future<void> uploadDocument({
    required String documentType,
    required String customDocumentType,
    required String expiryDate,
    files,
  })async{

    final selectedDocumentType = documentType == 'Other' ? customDocumentType : documentType;
    final newDocument = VehicleDocument(
      documentType : selectedDocumentType,
      expiryDate : expiryDate,
    );

    // Schedule expiry notification for the new document
    LocalNotifications.scheduleDocumentExpiryNotification(newDocument);
    LocalNotifications.checkScheduledNotifications();

    try{
      final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          throw "Network error";
        }
        
    await _docRepository.addDocumentRecord(newDocument, files);

    MLoaders.successSnackBar(title: 'Success', message: 'Document uploaded');
    Get.to(() => const HomeScreen());

    } catch (e) {
        MLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }



}
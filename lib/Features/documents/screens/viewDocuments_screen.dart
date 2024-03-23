// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../data/repositories/documents/documents_repository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import '../../../utils/constants/sizes.dart';
import '../../Home/screens/home_screens.dart';
import '../models/document_model.dart';
import 'uploading_screen.dart';

class ViewDocuments extends StatefulWidget {
  const ViewDocuments({Key? key}) : super(key: key);

  @override
  _ViewDocumentsState createState() => _ViewDocumentsState();
}

class _ViewDocumentsState extends State<ViewDocuments>{

  final currentVehicle = VehicleRepository.instance.currentVehicle.vehicleNo;

  List<VehicleDocument> _uploadedDocuments = [];

  @override
  void initState() {
    super.initState();
    _fetchUploadedDocuments(); 
  }

  Future<void> _fetchUploadedDocuments() async {

    DocumentRepository documentRepository = DocumentRepository();
    List<VehicleDocument> documents = await documentRepository.fetchVehicleDocuments();
    setState(() {
      _uploadedDocuments = documents;
    });
  }
  
   Widget _buildUploadedDocumentsList() {
    if(_uploadedDocuments.isEmpty){
      return const Center(child: Text('No documents uploaded yet.'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _uploadedDocuments.length,
      itemBuilder: (context, index) {
        VehicleDocument doc = _uploadedDocuments[index];
        return ListTile(
          title: Text(doc.documentType,style: const TextStyle(fontSize: TSizes.fontSizeSm, fontWeight: FontWeight.bold),),
          subtitle: Text('Expires on: ${doc.expiryDate}'),
          leading: const Icon(Icons.file_copy_outlined),
          trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios), 
          onPressed: () async {
           if (doc.fileUrl != null && await canLaunch(doc.fileUrl!)) {
            await launch(doc.fileUrl!);
            }
          },
        ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Documents'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const HomeScreen()));
            })
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUploadedDocumentsList(),
            const SizedBox(height:550),
            const Divider(),
             Text(
                  "Documents of $currentVehicle",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(   
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text('Upload New Document'),
                      onPressed: () => Get.to(() =>const DocumentsPage())
                    ),
                    
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
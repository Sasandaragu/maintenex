import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:maintenex/data/repositories/documents/documents_repository.dart';
import 'package:maintenex/features/Home/screens/home_screens.dart';
import 'package:maintenex/features/documents/controllers/upload_controller.dart';
import 'package:maintenex/features/documents/screens/viewDocuments_screen.dart';
import 'package:maintenex/features/reminders/screens/local_notifications.dart';
import 'package:maintenex/utils/validators/validation.dart';


class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedDocumentType = 'Driver\'s License';
  String _customDocumentType = '';
  final  TextEditingController _dateController = TextEditingController();
  List<PlatformFile>? _pickedFiles;
  final List<String> _documentTypes = [
    'Driver\'s License',
    'Vehicle License',
    'Vehicle Insurance',
    'Vehicle Emission Report',
    'Other',
  ];


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2045),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate); // Format and set date
      });
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
   
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpeg', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _pickedFiles = result.files; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ViewDocuments()));
            })),
      body: SingleChildScrollView(
         padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedDocumentType,
                
                items: _documentTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                    _selectedDocumentType = value!;
                    if (_selectedDocumentType != 'Other') {
                      _customDocumentType = ''; // Reset custom type if 'Other' is not selected
                    }
                  }),
              ),
              const SizedBox(height: 20),
              if (_selectedDocumentType == 'Other') ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Enter Document Type'),
                  onChanged: (value) {
                    _customDocumentType = value;
                  },
                
                ),
              const SizedBox(height: 20),  
              ],
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Expiry Date*',
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller: _dateController,
                onTap: () => _selectDate(context), // Open date picker on tap
                validator: (value) =>
                    MValidator.validateEmptyText('Date', value),
              ),

              const SizedBox(height: 20),
              Column(
                children: [
                  OutlinedButton(
                    onPressed: _pickFiles,
                    child: const Text('Add Document '), 
                  ),
                  if (_pickedFiles != null && _pickedFiles!.isNotEmpty) 
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _pickedFiles!.map((file) => Text(
                        'Selected file: ${file.name}',
                        style: const TextStyle(fontSize: 16),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),   
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: ElevatedButton(
                    child: const Text(' Upload Document  '),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final controller = DocumentUploadController();
                        await controller.uploadDocument(
                        documentType: _selectedDocumentType,
                        customDocumentType: _customDocumentType,
                        expiryDate: _dateController.text,
                        files: _pickedFiles,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } 
}

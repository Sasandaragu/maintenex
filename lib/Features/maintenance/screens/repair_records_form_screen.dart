import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/validators/validation.dart';
import '../controllers/repair_records_controllers.dart';
import 'repair_records_screen.dart';


class RepairRecordForm extends StatefulWidget {
  @override
  _RepairRecordFormState createState() => _RepairRecordFormState();
}

class _RepairRecordFormState extends State<RepairRecordForm> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController =
      TextEditingController(); // Date controller
      List<PlatformFile>? _pickedFiles; // Variable to hold the picked file

        final serviceProvider = TextEditingController();
        final totalCost = TextEditingController();
        final description = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
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
      allowMultiple: true, // Allow multiple file selection
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpeg', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _pickedFiles = result.files; // Update to hold multiple files
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repair Record Form'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const RepairRecordsScreen()));
            }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Create a New Repair Record",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              
              TextFormField(
                controller: serviceProvider,
                decoration: const InputDecoration(
                  labelText: 'Service Provider*',
                  prefixIcon: Icon(Icons.handyman),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    MValidator.validateEmptyText('Service Provider', value),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _dateController, // Use the controller here
                decoration: const InputDecoration(
                  labelText: 'Date*',
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Make it read-only
                onTap: () => _selectDate(context), // Open date picker on tap
                validator: (value) =>
                    MValidator.validateEmptyText('Date', value),
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: totalCost,
                decoration: const InputDecoration(
                  labelText: 'Total Cost',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    MValidator.validateEmptyText('Total Cost', value),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: description,
                decoration: const InputDecoration(
                  labelText: 'Description*',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    MValidator.validateEmptyText('Description', value),
              ),
              const SizedBox(
                height: 20,
              ),

              Column(
                children: [
                  OutlinedButton(
                    onPressed: _pickFiles,
                    child: Text('  Upload Invoice  '),
                    
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

              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final controller = RepairRecordController();

                    await controller.submitRepairRecord(
                      serviceProvider: serviceProvider.text.trim(),
                      date: _dateController.text,
                      totalCost: double.parse(totalCost.text.trim()),
                      description: description.text.trim(),
                      invoiceFiles: _pickedFiles,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



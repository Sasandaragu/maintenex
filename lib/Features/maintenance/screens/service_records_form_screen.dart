import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/validators/validation.dart';
import '../controllers/service_records_controllers.dart';
import 'service_records_screen.dart';


class ServiceRecordForm extends StatefulWidget {
  const ServiceRecordForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceRecordFormState createState() => _ServiceRecordFormState();
}

class _ServiceRecordFormState extends State<ServiceRecordForm> {
  final _formKey = GlobalKey<FormState>();
  bool _enableAlert = false;
  final TextEditingController _dateController =
      TextEditingController(); // Date controller
  List<PlatformFile>? _pickedFiles; // Variable to hold the picked file

  final serviceProvider = TextEditingController();
  final recommendedMileage = TextEditingController();
  final totalCost = TextEditingController();
  final description = TextEditingController();
  final recommendedLifetime = TextEditingController();

  double mileage = 0;
  double lifetime = 0;

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
        title: const Text('Service Record Form'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ServiceRecordsScreen()));
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
                "Create a New Service Record",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: recommendedMileage,
                decoration: const InputDecoration(
                  labelText: 'Recommended Mileage (Km)',
                  prefixIcon: Icon(Icons.local_gas_station),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: recommendedLifetime,
                decoration: const InputDecoration(
                  labelText: 'Recommended Lifetime (Months)',
                  prefixIcon: Icon(Icons.hourglass_bottom),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: totalCost,
                decoration: const InputDecoration(
                  labelText: 'Total Cost*',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    MValidator.validateEmptyText('Total Cost', value),
              ),
              const SizedBox(height: 20),
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
                    child: const Text('  Upload Invoice  '),
                  ),
                  if (_pickedFiles != null && _pickedFiles!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _pickedFiles!
                            .map((file) => Text(
                                  'Selected file: ${file.name}',
                                  style: const TextStyle(fontSize: 16),
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _enableAlert,
                    onChanged: (bool? value) {
                      setState(() {
                        _enableAlert = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: const Text(
                        'Recieve Alerts',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final controller = ServiceRecordController();

                    if (recommendedMileage.text.isNotEmpty) {
                      mileage = double.parse(recommendedMileage.text.trim());
                    }

                    if (recommendedLifetime.text.isNotEmpty) {
                      lifetime = double.parse(recommendedLifetime.text.trim());
                    }

                    await controller.submitServiceRecord(
                      serviceProvider: serviceProvider.text.trim(),
                      date: _dateController.text,
                      recommendedMileage: mileage,
                      recommendedLifetime: lifetime,
                      totalCost: double.parse(totalCost.text.trim()),
                      description: description.text.trim(),
                      invoiceFiles: _pickedFiles,
                      enableAlert: _enableAlert,
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

void main() {
  runApp(const MaterialApp(
    home: ServiceRecordForm(),
  ));
}

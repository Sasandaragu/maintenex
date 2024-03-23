import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenex/Features/maintenance/controllers/part_replacement_records_controllers.dart';
import 'package:maintenex/Features/maintenance/screens/part_replacement_records_screen.dart';
import 'package:maintenex/utils/validators/validation.dart';

class PartReplacementRecordForm extends StatefulWidget {
  @override
  _PartReplacementRecordFormState createState() => _PartReplacementRecordFormState();
}

class _PartReplacementRecordFormState extends State<PartReplacementRecordForm> {

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
        final replacedPart = TextEditingController();
        final warranty = TextEditingController();

        double mileage = 0;
        double lifetime = 0;
        double dWarranty = 0;

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
        title: Text('Part Replacement Record Form'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PartReplacementRecordsScreen()));
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
              SizedBox(height: 20),

              TextFormField(
                controller: replacedPart,
                decoration: const InputDecoration(
                  labelText: 'Replaced Part*',
                  prefixIcon: Icon(Icons.handyman),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    MValidator.validateEmptyText('Replaced Part', value),
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
                controller: recommendedMileage,
                decoration: const InputDecoration(
                  labelText: 'Recommended Mileage (Km)',
                  prefixIcon: Icon(Icons.local_gas_station),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: recommendedLifetime,
                decoration: const InputDecoration(
                  labelText: 'Recommended Lifetime (Months)',
                  prefixIcon: Icon(Icons.hourglass_bottom),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: warranty,
                decoration: const InputDecoration(
                  labelText: 'Warranty (Months / KM)',
                  prefixIcon: Icon(Icons.hourglass_bottom),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

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
                    final controller = PartReplacementRecordController();

                    if (recommendedMileage.text.isNotEmpty) {
                      mileage = double.parse(recommendedMileage.text.trim());
                    }

                    if (recommendedLifetime.text.isNotEmpty) {
                      lifetime = double.parse(recommendedLifetime.text.trim());
                    }

                    if (warranty.text.isNotEmpty) {
                      lifetime = double.parse(warranty.text.trim());
                    }

                    await controller.submitPartReplacementRecord(
                      replacedPart: replacedPart.text.trim(),
                      serviceProvider: serviceProvider.text.trim(),
                      date: _dateController.text,
                      recommendedMileage: mileage,
                      recommendedLifetime: lifetime,
                      warranty: dWarranty,
                      totalCost: double.parse(totalCost.text.trim()),
                      description: description.text.trim(),
                      files: _pickedFiles,
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
  runApp(MaterialApp(
    home: PartReplacementRecordForm(),
  ));
}

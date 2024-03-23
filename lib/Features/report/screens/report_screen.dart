import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/maintenex/part_replacement/partReplacementRecordRepository.dart';
import '../../../data/repositories/maintenex/repair_record/repairRecordRepository.dart';
import '../../../data/repositories/maintenex/service_record/serviceRecordRepository.dart';
import '../../../data/repositories/mileage/mileage_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/vehicle/vehicle_repository.dart';
import '../../personalization/models/user_model.dart';
import '../../vehicle/models/vehicle_model.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();



  Future<void> _generateReport() async {
    if (_formKey.currentState!.validate()) {
      int? month = int.tryParse(_monthController.text);
      int? year = int.tryParse(_yearController.text);

      if (month != null && year != null) {
        // Generate report
        await generateMonthlyReport(month, year);

        // View or share the report
        // ...
      } else {
        // Show some error to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Monthly Report"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _monthController,
                decoration: InputDecoration(
                  labelText: 'Enter Month Number (1-12)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! < 1 || int.tryParse(value)! > 12) {
                    return 'Please enter a valid month number between 1 and 12';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Enter Year',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! < 2000 || int.tryParse(value)! > 2025) {
                    return 'Please enter a valid year between 2000 and 2025';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: _generateReport,
              child: Text("Generate Report"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}


Future<void> generateMonthlyReport(int month, int year) async {
  final pdf = pw.Document();
  ServiceRecordRepository serviceRecordRepository = ServiceRecordRepository();
  PartReplacementRecordRepository partReplacementRecordRepository = PartReplacementRecordRepository();
  RepairRecordRepository repairRecordRepository = RepairRecordRepository();
  MileageRepository mileageRepository = MileageRepository();
  
  String userID = AuthenticationRepository.instance.authUser!.uid;
  UserModel user = await UserRepository.instance.fetchUserDetails();
  VehicleModel vehicle = VehicleRepository.instance.currentVehicle;

  // Fetch data from Firestore
  final serviceRecords = await serviceRecordRepository.fetchServiceRecordsForMonth(year,month);
  final partReplacementRecords = await partReplacementRecordRepository.fetchPartReplacementRecordsForMonth(year,month);
  final repairRecords = await repairRecordRepository.fetchRepairRecordsForMonth(year,month);
  final mileageRecords = await mileageRepository.fetchMileageRecordsForMonth(year,month);

  // Add pages to the PDF with your fetched data
  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Header(
          level: 0,
          child: pw.Row(
            children: [
              pw.Text('Maintenex Monthly Report', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Spacer(),
              pw.Text('${vehicle.vehicleNo} ($month/$year)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),

        pw.Row(
          children: [
            pw.Text('Username: ${user.fullName}'),
            pw.Spacer(),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text('Email: ${user.email}'),
            ),
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(5)),

        pw.Text('Vehicle Details -:',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Padding(padding: const pw.EdgeInsets.all(3)),

        pw.Text('   Vehicle Nickname: ${vehicle.vehicleNickname}'),
        pw.Text('   Vehicle Number: ${vehicle.vehicleNo}'),
        pw.Text('   Vehicle Type: ${vehicle.vehicleType}'),
        pw.Text('   Vehicle Brand: ${vehicle.vehicleBrand}'),
        pw.Text('   Mileage Travelled: ${vehicle.mileageTraveled}'),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),
        
        // Add other sections similarly, like Service Records, Part Replacement Records, etc.
        pw.Text('Service Records',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Padding(padding: const pw.EdgeInsets.all(5)),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Date', 'Service Provider', 'Cost'],
            ...serviceRecords.map((record) => [record.date, record.serviceProvider, record.totalCost.toString()]),
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),

        pw.Text('Part Replacement Records',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Padding(padding: const pw.EdgeInsets.all(5)),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Date', 'Service Provider', 'Cost'],
            ...partReplacementRecords.map((record) => [record.date, record.serviceProvider, record.totalCost.toString()]),
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),

        pw.Text('Repair Records',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Padding(padding: const pw.EdgeInsets.all(5)),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Date', 'Service Provider', 'Cost'],
            ...repairRecords.map((record) => [record.date, record.serviceProvider, record.totalCost.toString()]),
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),

        pw.Text('Mileage Records',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Padding(padding: const pw.EdgeInsets.all(5)),
        pw.Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Date', 'New Mileage', 'Difference'],
            ...mileageRecords.map((record) => [record.date, record.newMileage.toString(), record.difference.toString()]),
          ],
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(10)),

        // ... Repeat for other data categories
      ],
    ),
  );

  // Convert PDF document to bytes
  final Uint8List pdfBytes = await pdf.save();

  // Create a reference to the Firebase Storage location
  final storageRef = FirebaseStorage.instance.ref();
  final pdfRef = storageRef.child('$userID/${vehicle.vehicleNo}/Reports/${vehicle.vehicleNickname}_${year}_${month}_report.pdf');

  // Upload the PDF bytes
  try {
    await pdfRef.putData(pdfBytes);
    // Optionally, get the download URL for the uploaded PDF
    final downloadUrl = await pdfRef.getDownloadURL();
    print("PDF uploaded successfully. Download URL: $downloadUrl");
  } catch (e) {
    print("Error uploading PDF: $e");
  }

  // Share or open the file
  // Share.shareFiles([path], text: 'Your monthly vehicle report.');
  // Or open the file with a PDF viewer
}


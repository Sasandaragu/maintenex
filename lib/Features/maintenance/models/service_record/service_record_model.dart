import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRecordModel {
  String serviceProvider;
  String date;
  double recommendedMileage;
  double recommendedLifetime;
  double totalCost;
  String description;
  List<String>? fileUrls; // URLs of uploaded files
  bool enableAlert;

  ServiceRecordModel({
    required this.serviceProvider,
    required this.date,
    required this.recommendedMileage,
    required this.recommendedLifetime,
    required this.totalCost,
    required this.description,
    this.fileUrls,
    this.enableAlert = false,
  });

  // Convert a ServiceRecordModel instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'serviceProvider': serviceProvider,
      'date': date,
      'recommendedMileage': recommendedMileage,
      'recommendedLifetime': recommendedLifetime,
      'totalCost': totalCost,
      'description': description,
      'fileUrls': fileUrls,
      'enableAlert': enableAlert,
    };
  }

  // Create a ServiceRecordModel from a Map
  factory ServiceRecordModel.fromMap(Map<String, dynamic> map) {
    return ServiceRecordModel(
      serviceProvider: map['serviceProvider'] ?? '',
      date: map['date'] ?? '',
      recommendedMileage: map['recommendedMileage'] ?? '',
      recommendedLifetime: map['recommendedLifetime'] ?? '',
      totalCost: map['totalCost'] ?? '',
      description: map['description'] ?? '',
      fileUrls: List<String>.from(map['fileUrls'] ?? []),
      enableAlert: map['enableAlert'] ?? false,
    );
  }
  factory ServiceRecordModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return ServiceRecordModel(
      serviceProvider: data['serviceProvider'],
      date: data['date'],
      recommendedMileage: data['recommendedMileage'],
      recommendedLifetime: data['recommendedLifetime'],
      totalCost: data['totalCost'],
      description: data['description'],
      fileUrls: data['fileUrls'],
      enableAlert: data['enableAlert'],
    );
  }
}

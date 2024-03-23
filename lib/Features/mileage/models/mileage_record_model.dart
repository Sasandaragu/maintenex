import 'package:cloud_firestore/cloud_firestore.dart';

class MileageRecordModel {
  String date;
  double preMileage;
  double newMileage;
  double difference;

  MileageRecordModel({
    required this.date,
    required this.preMileage,
    required this.newMileage,
    required this.difference
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'preMileage': preMileage,
      'newMileage': newMileage,
      'difference': difference
    };
  }

  factory MileageRecordModel.fromMap(Map<String, dynamic> map) {
    return MileageRecordModel(
      date: map['date'] ?? '', 
      preMileage: map['preMileage'] ?? '', 
      newMileage: map['newMileage'] ?? '', 
      difference: map['difference'] ?? ''
    );
  }

  static MileageRecordModel empty() => MileageRecordModel(date: '', preMileage: 0, newMileage: 0, difference: 0);
}
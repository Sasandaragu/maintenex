import 'package:cloud_firestore/cloud_firestore.dart';

class FuelRecordModel {
  double amount;

  FuelRecordModel({
    required this.amount
  });

  Map<String, dynamic> toMap() {
    return {
      'date': FieldValue.serverTimestamp(),
      'amount': amount
    };
  }
}
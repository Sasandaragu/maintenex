import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleModel{

  final String vehicleNo;
  final String vehicleType;
  final String vehicleBrand;
  final String vehicleNickname;
  final double mileageTraveled;
  final String userID;


VehicleModel({
  required this.vehicleNo,
  required this.vehicleType,
  required this.vehicleBrand,
  required this.vehicleNickname,
  required this.mileageTraveled,
  required this.userID,
});


Map <String, dynamic> toJson () {
    return {
      "VehicleNo": vehicleNo,
      "vehicleType": vehicleType,
      "vehicleBrand":vehicleBrand,
      "vehicleNickname": vehicleNickname,
      "mileageTraveled": mileageTraveled,
      "userID": userID,
    };
  }

  factory VehicleModel.fromFirestore(Map<String, dynamic> firestore) {
    return VehicleModel(
      vehicleNo: firestore['VehicleNo'] as String,
      vehicleType: firestore['vehicleType'] as String, 
      vehicleNickname: firestore['vehicleNickname'] as String,
      mileageTraveled: firestore['mileageTraveled'] as double,
      userID: firestore['userID'] as String,
      vehicleBrand: firestore['vehicleBrand'] as String,
    );
  }

  static VehicleModel empty() => VehicleModel(userID: '', vehicleNo: '', vehicleNickname: '', vehicleType: '', mileageTraveled: 0, vehicleBrand: '');

  factory VehicleModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data()!= null) {
      final data = document.data()! ;
      return VehicleModel(
        userID: data ['userID'] ?? '',
        vehicleNo: data ['VehicleNo'] ?? '',
        vehicleNickname: data['vehicleNickname'] ?? '',
        vehicleType: data['vehicleType'] ?? '',
        mileageTraveled: data['mileageTraveled'] ?? '',
        vehicleBrand: data['vehicleBrand'] ?? ''
      );  
    }return VehicleModel.empty();
  }
}
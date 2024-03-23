class MileStoneModel {
  String maintenanceId;
  String title;
  double alertMileage;
  String recordType;
  String date;

  MileStoneModel({
    required this.maintenanceId,
    required this.title,
    required this.alertMileage,
    required this.recordType,
    required this.date
  });

  Map<String, dynamic> toMap() {
    return {
      'maintenanceId' : maintenanceId,
      'title' : title,
      'alertMileage' : alertMileage,
      'recordType' : recordType,
      'date' : date
    };
  }

  factory MileStoneModel.fromMap(Map<String, dynamic> map) {
    return MileStoneModel(
      maintenanceId: map['maintenanceId'] ?? '', 
      title: map['title'] ?? '', 
      alertMileage: map['alertMileage'] ?? '', 
      recordType: map['recordType'] ?? '', 
      date: map['date'] ?? ''
    );
  }
}
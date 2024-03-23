class PartReplacementRecordModel {
  String replacedPart;
  String serviceProvider;
  String date;
  double recommendedMileage;
  double recommendedLifetime;
  double warranty;
  double totalCost;
  String description;
  List<String>? fileUrls; 
  bool enableAlert;

  PartReplacementRecordModel({
    
    required this.replacedPart,
    required this.serviceProvider,
    required this.date,
    required this.recommendedMileage,
    required this.recommendedLifetime,
    required this.warranty,
    required this.totalCost,
    required this.description,
    this.fileUrls,
    this.enableAlert = false,
  });

  // Convert a ServiceRecordModel instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'replacedPart': replacedPart,
      'serviceProvider': serviceProvider,
      'date': date,
      'recommendedMileage': recommendedMileage,
      'recommendedLifetime': recommendedLifetime,
      'warranty': warranty,
      'totalCost': totalCost,
      'description': description,
      'fileUrls': fileUrls,
      'enableAlert': enableAlert,
    };
  }

  // Create a ServiceRecordModel from a Map
  factory PartReplacementRecordModel.fromMap(Map<String, dynamic> map) {
    return PartReplacementRecordModel(
      replacedPart: map['replacedPart'] ?? '',
      serviceProvider: map['serviceProvider'] ?? '',
      date: map['date'] ?? '',
      recommendedMileage: map['recommendedMileage'] ?? '',
      recommendedLifetime: map['recommendedLifetime'] ?? '',
      warranty: map['warranty'] ?? '',
      totalCost: map['totalCost'] ?? '',
      description: map['description'] ?? '',
      fileUrls: List<String>.from(map['fileUrls'] ?? []),
      enableAlert: map['enableAlert'] ?? false,
    );
  }
}

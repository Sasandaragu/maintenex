class RepairRecordModel {
  String serviceProvider;
  String date;
  double totalCost;
  String description;
  List<String>? fileUrls; // URLs of uploaded files

  RepairRecordModel({
    required this.serviceProvider,
    required this.date,
    required this.totalCost,
    required this.description,
    this.fileUrls,
  });

  // Convert a ServiceRecordModel instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'serviceProvider': serviceProvider,
      'date': date,
      'totalCost': totalCost,
      'description': description,
      'fileUrls': fileUrls,
    };
  }

  // Create a ServiceRecordModel from a Map
  factory RepairRecordModel.fromMap(Map<String, dynamic> map) {
    return RepairRecordModel(
      serviceProvider: map['serviceProvider'] ?? '',
      date: map['date'] ?? '',
      totalCost: map['totalCost'] ?? '',
      description: map['description'] ?? '',
      fileUrls: List<String>.from(map['fileUrls'] ?? []),
    );
  }
}

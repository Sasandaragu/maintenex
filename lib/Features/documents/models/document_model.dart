class VehicleDocument {
  String documentType;
  String expiryDate;
  String? fileUrl;

  VehicleDocument({
    required this.documentType, 
    required this.expiryDate, 
    this.fileUrl
    
  });

  Map<String, dynamic> toMap() => {
        'documentType': documentType,
        'expiryDate': expiryDate,
        'fileUrl': fileUrl,
      };

  factory VehicleDocument.fromMap(Map<String, dynamic> map) {
    return VehicleDocument(
      documentType: map['documentType']?? '',
      expiryDate: map['expiryDate'] ?? '',
      fileUrl: map['fileUrl'] );
  } 
}

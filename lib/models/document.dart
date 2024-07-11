class Document {
  final String id;
  final String fileName;
  final String filePath;
  final int fileSize;

  Document({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['_id'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileSize: json['fileSize'],
    );
  }
}

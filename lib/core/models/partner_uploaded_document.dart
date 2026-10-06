import 'dart:convert';

/// One uploaded verification document on Partner Application step 3.
class PartnerUploadedDocument {
  const PartnerUploadedDocument({
    required this.id,
    required this.fileName,
    required this.docType,
    this.format = 'PDF',
    required this.uploadedAt,
  });

  final String id;
  final String fileName;
  final String docType;
  final String format;
  final DateTime uploadedAt;

  String get metaLine {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final d = uploadedAt;
    final date = '${months[d.month - 1]} ${d.day}, ${d.year}';
    return '$docType • $format • $date';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'file_name': fileName,
        'doc_type': docType,
        'format': format,
        'uploaded_at': uploadedAt.toIso8601String(),
      };

  factory PartnerUploadedDocument.fromJson(Map<String, dynamic> json) {
    return PartnerUploadedDocument(
      id: json['id'] as String? ?? '',
      fileName: json['file_name'] as String? ?? '',
      docType: json['doc_type'] as String? ?? '',
      format: json['format'] as String? ?? 'PDF',
      uploadedAt: DateTime.tryParse(json['uploaded_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  String encode() => jsonEncode(toJson());
}

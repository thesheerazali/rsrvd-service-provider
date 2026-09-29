import 'dart:convert';

import 'partner_uploaded_document.dart';

/// Draft partner application — built across the 4 onboarding steps.
/// Persisted shape mirrors a future Firestore `partner_applications/{uid}` doc.
class PartnerApplicationDraft {
  const PartnerApplicationDraft({
    this.contactName = '',
    this.phone = '',
    this.businessName = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.experienceYears = '',
    this.bio = '',
    this.expertise = const [],
    this.serviceAreas = const [],
    this.categoryIds = const [],
    this.documents = const [],
    this.ndaAccepted = false,
  });

  final String contactName;
  final String phone;
  final String businessName;
  final String city;
  final String state;
  final String country;
  final String experienceYears;
  final String bio;
  final List<String> expertise;
  final List<String> serviceAreas;
  final List<String> categoryIds;
  final List<PartnerUploadedDocument> documents;
  final bool ndaAccepted;

  PartnerApplicationDraft copyWith({
    String? contactName,
    String? phone,
    String? businessName,
    String? city,
    String? state,
    String? country,
    String? experienceYears,
    String? bio,
    List<String>? expertise,
    List<String>? serviceAreas,
    List<String>? categoryIds,
    List<PartnerUploadedDocument>? documents,
    bool? ndaAccepted,
  }) {
    return PartnerApplicationDraft(
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      businessName: businessName ?? this.businessName,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      experienceYears: experienceYears ?? this.experienceYears,
      bio: bio ?? this.bio,
      expertise: expertise ?? this.expertise,
      serviceAreas: serviceAreas ?? this.serviceAreas,
      categoryIds: categoryIds ?? this.categoryIds,
      documents: documents ?? this.documents,
      ndaAccepted: ndaAccepted ?? this.ndaAccepted,
    );
  }

  Map<String, dynamic> toJson() => {
        'contact_name': contactName,
        'phone': phone,
        'business_name': businessName,
        'city': city,
        'state': state,
        'country': country,
        'experience_years': experienceYears,
        'bio': bio,
        'expertise': expertise,
        'service_areas': serviceAreas,
        'category_ids': categoryIds,
        'documents': documents.map((d) => d.toJson()).toList(),
        'nda_accepted': ndaAccepted,
      };

  factory PartnerApplicationDraft.fromJson(Map<String, dynamic> json) {
    List<String> list(dynamic raw) {
      if (raw is! List) return const [];
      return raw.map((e) => e.toString()).toList();
    }

    List<PartnerUploadedDocument> docs(dynamic raw) {
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map(
            (e) => PartnerUploadedDocument.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    }

    return PartnerApplicationDraft(
      contactName: json['contact_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      businessName: json['business_name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      experienceYears: json['experience_years'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      expertise: list(json['expertise']),
      serviceAreas: list(json['service_areas']),
      categoryIds: list(json['category_ids']),
      documents: docs(json['documents']),
      ndaAccepted: json['nda_accepted'] as bool? ?? false,
    );
  }

  String encode() => jsonEncode(toJson());

  static PartnerApplicationDraft? tryDecode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return null;
      return PartnerApplicationDraft.fromJson(Map<String, dynamic>.from(map));
    } catch (_) {
      return null;
    }
  }
}

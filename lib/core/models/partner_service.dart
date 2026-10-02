/// Partner service listing — mirrors future `services/{id}` / provider catalog item.
class PartnerService {
  const PartnerService({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.priceLabel,
    this.isPublished = true,
    this.isBoosted = false,
    this.reviewStatus = PartnerServiceReviewStatus.approved,
    this.rejectionReason = '',
    this.imageCount = 0,
  });

  final String id;
  final String title;
  final String category;
  final String description;

  /// Display price line — e.g. `$150,000 · Starting From`.
  final String priceLabel;

  final bool isPublished;
  final bool isBoosted;
  final PartnerServiceReviewStatus reviewStatus;

  /// Shown on rejected status screen (Figma reason card).
  final String rejectionReason;

  /// Demo / local photo slot count (max 6).
  final int imageCount;

  /// Show Boost CTA when published, approved, and not already boosted.
  bool get canBoost =>
      isPublished &&
      !isBoosted &&
      reviewStatus == PartnerServiceReviewStatus.approved;

  bool get isPendingReview =>
      reviewStatus == PartnerServiceReviewStatus.pending;

  PartnerService copyWith({
    String? title,
    String? category,
    String? description,
    String? priceLabel,
    bool? isPublished,
    bool? isBoosted,
    PartnerServiceReviewStatus? reviewStatus,
    String? rejectionReason,
    int? imageCount,
  }) {
    return PartnerService(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      priceLabel: priceLabel ?? this.priceLabel,
      isPublished: isPublished ?? this.isPublished,
      isBoosted: isBoosted ?? this.isBoosted,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      imageCount: imageCount ?? this.imageCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'price_label': priceLabel,
        'is_published': isPublished,
        'is_boosted': isBoosted,
        'review_status': reviewStatus.key,
        'rejection_reason': rejectionReason,
        'image_count': imageCount,
      };

  factory PartnerService.fromJson(Map<String, dynamic> json) {
    return PartnerService(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priceLabel: json['price_label'] as String? ?? '',
      isPublished: json['is_published'] as bool? ?? true,
      isBoosted: json['is_boosted'] as bool? ?? false,
      reviewStatus:
          PartnerServiceReviewStatusX.fromKey(json['review_status'] as String?),
      rejectionReason: json['rejection_reason'] as String? ?? '',
      imageCount: json['image_count'] as int? ?? 0,
    );
  }
}

/// Backend review gate after publish — same lifecycle idea as partner application.
enum PartnerServiceReviewStatus { pending, approved, rejected }

extension PartnerServiceReviewStatusX on PartnerServiceReviewStatus {
  String get key => switch (this) {
        PartnerServiceReviewStatus.pending => 'pending',
        PartnerServiceReviewStatus.approved => 'approved',
        PartnerServiceReviewStatus.rejected => 'rejected',
      };

  static PartnerServiceReviewStatus fromKey(String? raw) {
    return switch (raw) {
      'pending' || 'in_review' => PartnerServiceReviewStatus.pending,
      'rejected' => PartnerServiceReviewStatus.rejected,
      _ => PartnerServiceReviewStatus.approved,
    };
  }
}

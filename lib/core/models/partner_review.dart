/// Member review shown on Partner Rating & Reviews — Figma `1196:3579`.
class PartnerReview {
  const PartnerReview({
    required this.id,
    required this.category,
    required this.rating,
    required this.body,
    required this.authorName,
    required this.dateLabel,
  });

  final String id;

  /// e.g. `Architect`
  final String category;
  final double rating;
  final String body;
  final String authorName;

  /// e.g. `Mar 25`
  final String dateLabel;

  String get ratingLabel => rating.toStringAsFixed(1);

  factory PartnerReview.fromJson(Map<String, dynamic> json) {
    return PartnerReview(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      body: json['body'] as String? ?? '',
      authorName: json['author_name'] as String? ?? '',
      dateLabel: json['date_label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'rating': rating,
        'body': body,
        'author_name': authorName,
        'date_label': dateLabel,
      };
}

/// Summary + list payload for Rating & Reviews.
class PartnerReviewsFeed {
  const PartnerReviewsFeed({
    required this.averageRating,
    required this.reviewCount,
    required this.reviews,
  });

  final double averageRating;
  final int reviewCount;
  final List<PartnerReview> reviews;

  String get averageLabel => averageRating.toStringAsFixed(1);

  String get countLabel {
    final n = reviewCount.toString();
    return '$n member reviews';
  }
}

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
  });

  final String id;
  final String title;
  final String category;
  final String description;

  /// Display price line — e.g. `$150,000 · Starting From`.
  final String priceLabel;

  final bool isPublished;
  final bool isBoosted;

  /// Show Boost CTA when published and not already boosted.
  bool get canBoost => isPublished && !isBoosted;

  PartnerService copyWith({
    String? title,
    String? category,
    String? description,
    String? priceLabel,
    bool? isPublished,
    bool? isBoosted,
  }) {
    return PartnerService(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      priceLabel: priceLabel ?? this.priceLabel,
      isPublished: isPublished ?? this.isPublished,
      isBoosted: isBoosted ?? this.isBoosted,
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
    );
  }
}

/// Billing cadence for a catalog [MembershipPlan].
enum MembershipBillingInterval {
  monthly,
  yearly,
}

extension MembershipBillingIntervalX on MembershipBillingInterval {
  String get storageValue => name;

  static MembershipBillingInterval fromStorage(String? raw) {
    return MembershipBillingInterval.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => MembershipBillingInterval.yearly,
    );
  }
}

/// Catalog plan from the membership API / payment gateway.
///
/// Backend shape (any gateway): `GET /membership/plans` → list of these.
/// Prices stay integer cents so Stripe / Apple / Play map cleanly.
class MembershipPlan {
  const MembershipPlan({
    required this.id,
    required this.code,
    required this.name,
    required this.interval,
    required this.priceCents,
    this.currency = 'USD',
    this.features = const [],
    this.recommended = false,
    this.badgeLabel,
    this.secondaryPriceCents,
    this.periodSuffix,
    this.ctaShortName,
    this.gatewayPriceId,
  });

  /// Server plan id (stable primary key).
  final String id;

  /// Stable product code — e.g. `annual`, `monthly`.
  final String code;

  /// Display name — e.g. `Yearly Plan`, `Monthly Plan`.
  final String name;

  final MembershipBillingInterval interval;

  /// Price in the smallest currency unit (e.g. cents).
  final int priceCents;

  /// ISO 4217 — default `USD`.
  final String currency;

  /// Bullet lines shown on the choose-plan card.
  final List<String> features;

  /// Highlight / default selection when offered.
  final bool recommended;

  /// Optional pill — e.g. `Best value • Recommended`.
  final String? badgeLabel;

  /// Optional equivalent monthly amount for yearly cards (`$450/month`).
  final int? secondaryPriceCents;

  /// Period suffix after price — Figma uses `/year` or `/Monthly`.
  final String? periodSuffix;

  /// Short name for CTA — Figma `Continue with Annual`.
  final String? ctaShortName;

  /// Optional Stripe Price / StoreKit product id for checkout.
  final String? gatewayPriceId;

  String get priceFormatted => _formatCents(priceCents);

  String get secondaryPriceFormatted =>
      secondaryPriceCents == null ? '' : _formatCents(secondaryPriceCents!);

  String get periodLabel =>
      periodSuffix ??
      switch (interval) {
        MembershipBillingInterval.yearly => '/year',
        MembershipBillingInterval.monthly => '/Monthly',
      };

  /// Home card line — e.g. `Membership · Yearly`.
  String get homeLabel => switch (interval) {
        MembershipBillingInterval.yearly => 'Membership · Yearly',
        MembershipBillingInterval.monthly => 'Membership · Monthly',
      };

  /// CTA — e.g. `Continue with Annual`.
  String get continueCtaLabel =>
      'Continue with ${ctaShortName ?? name}';

  static String _formatCents(int cents) {
    final major = cents / 100;
    if (major == major.roundToDouble()) {
      return '\$${major.toStringAsFixed(0)}';
    }
    return '\$${major.toStringAsFixed(2)}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'interval': interval.storageValue,
        'price_cents': priceCents,
        'currency': currency,
        'features': features,
        'recommended': recommended,
        if (badgeLabel != null) 'badge_label': badgeLabel,
        if (secondaryPriceCents != null)
          'secondary_price_cents': secondaryPriceCents,
        if (periodSuffix != null) 'period_suffix': periodSuffix,
        if (ctaShortName != null) 'cta_short_name': ctaShortName,
        if (gatewayPriceId != null) 'gateway_price_id': gatewayPriceId,
      };

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      interval: MembershipBillingIntervalX.fromStorage(
        json['interval'] as String?,
      ),
      priceCents: (json['price_cents'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
      features: (json['features'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      recommended: json['recommended'] as bool? ?? false,
      badgeLabel: json['badge_label'] as String?,
      secondaryPriceCents: (json['secondary_price_cents'] as num?)?.toInt(),
      periodSuffix: json['period_suffix'] as String?,
      ctaShortName: json['cta_short_name'] as String?,
      gatewayPriceId: json['gateway_price_id'] as String?,
    );
  }
}

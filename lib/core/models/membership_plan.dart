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
    this.tagline,
    this.constraintNote,
    this.secondaryPriceCents,
    this.periodSuffix,
    this.ctaShortName,
    this.gatewayPriceId,
  });

  /// Server plan id (stable primary key).
  final String id;

  /// Stable product code — e.g. `access`, `featured`, `national`.
  final String code;

  /// Display name — e.g. `RSRVD Access`.
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

  /// Optional pill — e.g. `Best value · Recommended`.
  final String? badgeLabel;

  /// Short pitch under the title/price row — e.g. `Establish your presence`.
  final String? tagline;

  /// Optional constraint under the title — e.g. National exclusivity note.
  final String? constraintNote;

  /// Optional equivalent monthly amount for yearly cards (`$208/month`).
  final int? secondaryPriceCents;

  /// Period suffix after price — Figma uses ` yearly`.
  final String? periodSuffix;

  /// Short name for legacy CTAs — prefer [continueCtaLabel] translation.
  final String? ctaShortName;

  /// Optional Stripe Price / StoreKit product id for checkout.
  final String? gatewayPriceId;

  String get priceFormatted => _formatCents(priceCents);

  String get secondaryPriceFormatted =>
      secondaryPriceCents == null ? '' : _formatCents(secondaryPriceCents!);

  String get periodLabel =>
      periodSuffix ??
      switch (interval) {
        MembershipBillingInterval.yearly => ' yearly',
        MembershipBillingInterval.monthly => '/month',
      };

  /// Home card line — e.g. `Membership · Access`.
  String get homeLabel {
    final short = name.replaceFirst(RegExp(r'^RSRVD\s+', caseSensitive: false), '');
    if (short.isNotEmpty) return 'Membership · $short';
    return switch (interval) {
      MembershipBillingInterval.yearly => 'Membership · Yearly',
      MembershipBillingInterval.monthly => 'Membership · Monthly',
    };
  }

  /// CTA on choose-plan — Figma `Continue to payment`.
  String get continueCtaLabel => 'membership_continue_payment';

  static String _formatCents(int cents) {
    final major = cents / 100;
    final whole = major == major.roundToDouble()
        ? major.toInt()
        : null;
    if (whole != null) {
      return '\$${_withThousands(whole)}';
    }
    return '\$${major.toStringAsFixed(2)}';
  }

  static String _withThousands(int value) {
    final raw = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      final fromEnd = raw.length - i;
      if (i > 0 && fromEnd % 3 == 0) buf.write(',');
      buf.write(raw[i]);
    }
    return buf.toString();
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
        if (tagline != null) 'tagline': tagline,
        if (constraintNote != null) 'constraint_note': constraintNote,
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
      tagline: json['tagline'] as String?,
      constraintNote: json['constraint_note'] as String?,
      secondaryPriceCents: (json['secondary_price_cents'] as num?)?.toInt(),
      periodSuffix: json['period_suffix'] as String?,
      ctaShortName: json['cta_short_name'] as String?,
      gatewayPriceId: json['gateway_price_id'] as String?,
    );
  }
}

import 'membership_plan.dart';

/// Subscription state on the user document (`users/{uid}.membership`).
///
/// Backend writes this after checkout succeeds (Stripe webhook / IAP).
enum MembershipStatus {
  /// No plan purchased yet.
  none,

  /// Checkout started / pending confirmation.
  pending,

  /// Paid and in good standing.
  active,

  /// Payment failed — grace period.
  pastDue,

  /// User cancelled — may still be active until [endsAt].
  cancelled,

  /// Access ended.
  expired,
}

extension MembershipStatusX on MembershipStatus {
  String get storageValue => name;

  static MembershipStatus fromStorage(String? raw) {
    return MembershipStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => MembershipStatus.none,
    );
  }

  bool get isActiveAccess =>
      this == MembershipStatus.active || this == MembershipStatus.cancelled;
}

/// Embedded membership block on [AppUser] — gateway-agnostic.
class UserMembership {
  const UserMembership({
    this.status = MembershipStatus.none,
    this.planId,
    this.planCode,
    this.planName,
    this.interval,
    this.currency = 'USD',
    this.priceCents,
    this.startsAt,
    this.renewsAt,
    this.endsAt,
    this.gatewaySubscriptionId,
  });

  static const empty = UserMembership();

  final MembershipStatus status;

  /// Catalog plan id that was purchased.
  final String? planId;

  /// Snapshot of plan code at purchase — e.g. `annual`.
  final String? planCode;

  /// Snapshot of display name — e.g. `Annual`.
  final String? planName;

  final MembershipBillingInterval? interval;

  final String currency;
  final int? priceCents;

  final DateTime? startsAt;
  final DateTime? renewsAt;
  final DateTime? endsAt;

  /// Stripe subscription id / StoreKit original transaction id.
  final String? gatewaySubscriptionId;

  bool get hasPlan => planId != null && planId!.isNotEmpty;

  bool get isActive => status == MembershipStatus.active;

  String get homeLabel {
    if (interval == MembershipBillingInterval.monthly) {
      return 'Membership · Monthly';
    }
    if (interval == MembershipBillingInterval.yearly || hasPlan) {
      return 'Membership · Yearly';
    }
    return 'Membership';
  }

  String get statusLabel => switch (status) {
        MembershipStatus.active => 'Active',
        MembershipStatus.pending => 'Pending',
        MembershipStatus.pastDue => 'Past due',
        MembershipStatus.cancelled => 'Cancelled',
        MembershipStatus.expired => 'Expired',
        MembershipStatus.none => 'Inactive',
      };

  String get renewsLabel {
    final at = renewsAt ?? endsAt;
    if (at == null) return '';
    const months = [
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
    final d =
        '${months[at.month - 1]} ${at.day.toString().padLeft(2, '0')}, ${at.year}';
    return status == MembershipStatus.cancelled
        ? 'Ends $d'
        : 'Renews $d';
  }

  UserMembership copyWith({
    MembershipStatus? status,
    String? planId,
    String? planCode,
    String? planName,
    MembershipBillingInterval? interval,
    String? currency,
    int? priceCents,
    DateTime? startsAt,
    DateTime? renewsAt,
    DateTime? endsAt,
    String? gatewaySubscriptionId,
  }) {
    return UserMembership(
      status: status ?? this.status,
      planId: planId ?? this.planId,
      planCode: planCode ?? this.planCode,
      planName: planName ?? this.planName,
      interval: interval ?? this.interval,
      currency: currency ?? this.currency,
      priceCents: priceCents ?? this.priceCents,
      startsAt: startsAt ?? this.startsAt,
      renewsAt: renewsAt ?? this.renewsAt,
      endsAt: endsAt ?? this.endsAt,
      gatewaySubscriptionId:
          gatewaySubscriptionId ?? this.gatewaySubscriptionId,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status.storageValue,
        if (planId != null) 'plan_id': planId,
        if (planCode != null) 'plan_code': planCode,
        if (planName != null) 'plan_name': planName,
        if (interval != null) 'interval': interval!.storageValue,
        'currency': currency,
        if (priceCents != null) 'price_cents': priceCents,
        if (startsAt != null) 'starts_at': startsAt!.toIso8601String(),
        if (renewsAt != null) 'renews_at': renewsAt!.toIso8601String(),
        if (endsAt != null) 'ends_at': endsAt!.toIso8601String(),
        if (gatewaySubscriptionId != null)
          'gateway_subscription_id': gatewaySubscriptionId,
      };

  factory UserMembership.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return UserMembership.empty;
    return UserMembership(
      status: MembershipStatusX.fromStorage(json['status'] as String?),
      planId: json['plan_id'] as String?,
      planCode: json['plan_code'] as String?,
      planName: json['plan_name'] as String?,
      interval: json['interval'] != null
          ? MembershipBillingIntervalX.fromStorage(json['interval'] as String?)
          : null,
      currency: json['currency'] as String? ?? 'USD',
      priceCents: (json['price_cents'] as num?)?.toInt(),
      startsAt: _parseDate(json['starts_at']),
      renewsAt: _parseDate(json['renews_at']),
      endsAt: _parseDate(json['ends_at']),
      gatewaySubscriptionId: json['gateway_subscription_id'] as String?,
    );
  }

  /// Build an active membership snapshot from a catalog [plan].
  factory UserMembership.activeFromPlan(
    MembershipPlan plan, {
    DateTime? now,
    String? gatewaySubscriptionId,
  }) {
    final start = now ?? DateTime.now();
    final renews = switch (plan.interval) {
      MembershipBillingInterval.yearly =>
        DateTime(start.year + 1, start.month, start.day),
      MembershipBillingInterval.monthly =>
        DateTime(start.year, start.month + 1, start.day),
    };
    return UserMembership(
      status: MembershipStatus.active,
      planId: plan.id,
      planCode: plan.code,
      planName: plan.name,
      interval: plan.interval,
      currency: plan.currency,
      priceCents: plan.priceCents,
      startsAt: start,
      renewsAt: renews,
      gatewaySubscriptionId: gatewaySubscriptionId,
    );
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw is! String || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}

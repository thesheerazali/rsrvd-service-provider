import 'package:get/get.dart';

import '../../core/models/membership_plan.dart';
import '../../core/services/app_log.dart';

/// Membership catalog + checkout entrypoint.
///
/// Swap the local catalog / stub checkout for any payment gateway later:
/// - `listPlans()` → `GET /membership/plans`
/// - `startCheckout(plan)` → Stripe Checkout / PaymentSheet / IAP
class MembershipRepository extends GetxService {
  static const String _tag = 'MEMBERSHIP_REPO';

  static const _sharedFeatures = [
    'Verified RSRVD Partner profile',
    'Showcase your services and portfolio',
    'Connect with Elite Members',
    'Manage projects through RSRVD',
    'Access to RSRVD partner network',
    'Trusted Partner recognition',
  ];

  /// Local stand-in for `GET /membership/plans` until the API is wired.
  ///
  /// Copy / prices from Figma Member Screen `1196:164`.
  List<MembershipPlan> listPlans() {
    return const [
      MembershipPlan(
        id: 'plan_annual',
        code: 'annual',
        name: 'Yearly Plan',
        interval: MembershipBillingInterval.yearly,
        priceCents: 550000,
        secondaryPriceCents: 45000,
        periodSuffix: '/year',
        badgeLabel: 'Best value • Recommended',
        ctaShortName: 'Annual',
        features: _sharedFeatures,
        recommended: true,
        gatewayPriceId: 'price_annual_demo',
      ),
      MembershipPlan(
        id: 'plan_monthly',
        code: 'monthly',
        name: 'Monthly Plan',
        interval: MembershipBillingInterval.monthly,
        priceCents: 50000,
        periodSuffix: '/Monthly',
        ctaShortName: 'Monthly',
        features: _sharedFeatures,
        recommended: false,
        gatewayPriceId: 'price_monthly_demo',
      ),
    ];
  }

  MembershipPlan? planById(String id) {
    for (final plan in listPlans()) {
      if (plan.id == id) return plan;
    }
    return null;
  }

  /// Placeholder for gateway checkout. Returns a fake subscription id.
  ///
  /// Real flow: create PaymentIntent / Checkout Session → confirm → webhook
  /// updates `users/{uid}.membership`; FE then refreshes the user doc.
  Future<String> startCheckout(MembershipPlan plan) async {
    AppLog.i(
      'checkout stub plan=${plan.code} price=${plan.priceCents}',
      tag: _tag,
    );
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return 'sub_demo_${plan.code}_${DateTime.now().millisecondsSinceEpoch}';
  }
}

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

  /// Local stand-in for `GET /membership/plans` until the API is wired.
  ///
  /// Copy / prices from Figma Member Screen (Access / Featured / National).
  List<MembershipPlan> listPlans() {
    return const [
      MembershipPlan(
        id: 'plan_access',
        code: 'access',
        name: 'RSRVD Access',
        interval: MembershipBillingInterval.yearly,
        priceCents: 249900,
        secondaryPriceCents: 20800,
        periodSuffix: ' yearly',
        tagline: 'Establish your presence',
        features: [
          'Verified RSRVD Partner profile',
          'Showcase your services and portfolio',
          'Connect with Elite Members directly',
          'Manage projects through RSRVD app',
          'Access to RSRVD partner events',
          'Trusted Partner recognition through RSRVD member reviews.',
        ],
        recommended: false,
        gatewayPriceId: 'price_access_demo',
      ),
      MembershipPlan(
        id: 'plan_featured',
        code: 'featured',
        name: 'RSRVD Featured',
        interval: MembershipBillingInterval.yearly,
        priceCents: 449900,
        secondaryPriceCents: 37500,
        periodSuffix: ' yearly',
        badgeLabel: 'Best value · Recommended',
        tagline: 'Stand out in your market',
        features: [
          'Everything included in Access.',
          'Priority Placement within local market.',
          'Featured visibility in relevant member feeds.',
          'Increased exposure to local RSRVD members.',
        ],
        recommended: true,
        gatewayPriceId: 'price_featured_demo',
      ),
      MembershipPlan(
        id: 'plan_national',
        code: 'national',
        name: 'RSRVD National',
        interval: MembershipBillingInterval.yearly,
        priceCents: 1449900,
        secondaryPriceCents: 120800,
        periodSuffix: ' yearly',
        tagline: 'Expand your reach. Unlock New Markets.',
        constraintNote:
            'Only 1 National Brand Membership per Service Category',
        features: [
          'Everything included in Featured.',
          'Inclusion in relevant service provider searches beyond their home market.',
          'Priority placement in eligible markets.',
          "Expanded exposure to RSRVD's national member network.",
          'Trusted Partner recognition',
        ],
        recommended: false,
        gatewayPriceId: 'price_national_demo',
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

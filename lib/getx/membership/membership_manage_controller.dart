import 'package:get/get.dart';

import '../../core/models/membership_plan.dart';
import '../../core/models/user_membership.dart';
import '../../core/services/app_flash.dart';
import '../../data/repositories/user_repository.dart';

/// Settings / Home → Membership (active plan) — Partner manage UI.
class MembershipManageController extends GetxController {
  MembershipManageController({UserRepository? userRepository})
      : _users = userRepository ?? Get.find<UserRepository>();

  final UserRepository _users;

  final autoRenew = true.obs;

  static const includedBenefits = [
    'Verified listing in the RSRVD Elite Member directory.',
    'Direct member messaging and contract creation.',
    'Secured member payments and release on completion.',
    'Project workspace, documents and ratings.',
  ];

  UserMembership get _membership {
    final m = _users.currentUser?.membership;
    if (m != null && m.isActive && (m.priceCents ?? 0) > 0) {
      return m;
    }
    // UI-base demo snapshot — Featured plan.
    return UserMembership.activeFromPlan(
      const MembershipPlan(
        id: 'plan_featured',
        code: 'featured',
        name: 'RSRVD Featured',
        interval: MembershipBillingInterval.yearly,
        priceCents: 449900,
        recommended: true,
      ),
      now: DateTime(2026, 8, 8),
    );
  }

  String get planEyebrow =>
      _membership.planName?.isNotEmpty == true
          ? _membership.planName!
          : 'RSRVD Featured';

  String get statusLabel => _membership.statusLabel.toUpperCase();

  String get renewsHeadline {
    final label = _membership.renewsLabel;
    return label.isNotEmpty ? label : 'Renews Aug 08, 2027';
  }

  String get feeLabel => _formatCents(_membership.priceCents ?? 449900);

  String get feeRowLabel =>
      _membership.interval == MembershipBillingInterval.monthly
          ? 'membership_monthly_fee'.tr
          : 'membership_annual_fee'.tr;

  String get startedLabel => _formatDate(_membership.startsAt) ?? 'Aug 08, 2026';

  String get renewalLabel =>
      _formatDate(_membership.renewsAt) ?? 'Aug 08, 2027';

  void goBack() => Get.back();

  void setAutoRenew(bool value) => autoRenew.value = value;

  void openPaymentHistory() => AppFlash.info('coming_soon'.tr);

  String _formatCents(int cents) {
    final major = cents / 100;
    if (major == major.roundToDouble()) {
      final whole = major.toInt();
      final raw = whole.toString();
      final buf = StringBuffer();
      for (var i = 0; i < raw.length; i++) {
        final fromEnd = raw.length - i;
        if (i > 0 && fromEnd % 3 == 0) buf.write(',');
        buf.write(raw[i]);
      }
      return '\$$buf';
    }
    return '\$${major.toStringAsFixed(2)}';
  }

  String? _formatDate(DateTime? at) {
    if (at == null) return null;
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
    return '${months[at.month - 1]} ${at.day.toString().padLeft(2, '0')}, ${at.year}';
  }
}

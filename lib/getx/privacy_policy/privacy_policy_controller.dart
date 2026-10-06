import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  static const String body =
      'RSRVD collects identity and business details, verification documents, '
      'profile content, messages, contracts, project records, and payment '
      'history. We use this information to verify partners, present your '
      'profile to Elite Members, facilitate contracts and payments, and '
      'support disputes or compliance requests. Member identities and '
      'engagement details are kept confidential and shared with you only as '
      'needed to deliver an engagement, in accordance with your NDA. We may '
      'share information with payment processors and verification providers '
      'acting on our behalf, or when required by law, but we never sell '
      'partner or member data. Verification and contract records are retained '
      'for as long as required for legal, tax, and dispute-resolution '
      'purposes. You can edit your profile information, hide your directory '
      'listing, adjust notification preferences, or request account closure '
      'through the Partner Concierge.';

  void goBack() => Get.back();
}

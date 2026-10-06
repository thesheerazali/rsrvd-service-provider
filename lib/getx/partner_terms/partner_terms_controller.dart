import 'package:get/get.dart';

class PartnerTermsSection {
  const PartnerTermsSection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

/// Settings → Partner Terms.
class PartnerTermsController extends GetxController {
  static const sections = <PartnerTermsSection>[
    PartnerTermsSection(
      title: 'MEMBERSHIP',
      body:
          'RSRVD Partner membership is billed annually and grants a verified '
          'listing in the Elite Member directory. Membership does not '
          'guarantee engagements.',
    ),
    PartnerTermsSection(
      title: 'VERIFICATION',
      body:
          'You confirm that all licences, insurance and identity documents '
          'supplied are accurate and current, and you will update RSRVD '
          'promptly on any change.',
    ),
    PartnerTermsSection(
      title: 'CONTRACTS',
      body:
          'Contracts created in RSRVD are between you and the member. RSRVD '
          'facilitates the agreement, secures member payment and releases '
          'funds on accepted completion.',
    ),
    PartnerTermsSection(
      title: 'PAYMENTS',
      body:
          'Member payment is held by RSRVD once a contract is accepted and '
          'released to you after the member accepts project completion. '
          'Disputes are reviewed by RSRVD.',
    ),
    PartnerTermsSection(
      title: 'CONDUCT',
      body:
          'You will act professionally and discreetly, respond to member '
          'messages promptly, and deliver the scope agreed in each contract.',
    ),
    PartnerTermsSection(
      title: 'SUSPENSION',
      body:
          'RSRVD may suspend or remove a partner for confidentiality '
          'breaches, unresolved disputes, expired credentials or repeated '
          'non-delivery.',
    ),
  ];

  void goBack() => Get.back();
}

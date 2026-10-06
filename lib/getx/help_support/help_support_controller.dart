import 'package:get/get.dart';

import '../../core/services/app_flash.dart';
import '../../routes/app_routes.dart';
import '../main_shell/main_shell_controller.dart';

class HelpFaqItem {
  const HelpFaqItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;
}

class HelpSupportController extends GetxController {
  final expandedId = ''.obs;

  static const faqs = <HelpFaqItem>[
    HelpFaqItem(
      id: 'become_partner',
      question: 'How do I become an RSRVD Partner?',
      answer:
          'Complete sign-up, submit your Partner Application with verification '
          'documents, sign the Partner NDA, and activate membership once '
          'approved. Your profile then appears to Elite Members.',
    ),
    HelpFaqItem(
      id: 'verification',
      question: 'How long does the verification process take?',
      answer:
          'Most applications are reviewed within a few business days. You '
          'will see Submitted, Approved, or Rejected status in the app, with '
          'next steps if resubmission is needed.',
    ),
    HelpFaqItem(
      id: 'edit_profile',
      question: 'Can I edit my profile after it is approved?',
      answer:
          'Yes. Go to Profile → Settings → Edit profile to update your name, '
          'contact details, category, experience, expertise, and service areas.',
    ),
    HelpFaqItem(
      id: 'find_services',
      question: 'How do members find my services?',
      answer:
          'Elite Members browse the Partner directory and your published '
          'services. Keep your listing complete, accurate, and boosted when '
          'you want more visibility.',
    ),
    HelpFaqItem(
      id: 'member_interest',
      question: 'How will I know when a member is interested in my service?',
      answer:
          'You receive inquiries in Chats. Turn on Message Updates and New '
          'Opportunities under Settings → Notifications so you never miss a '
          'request.',
    ),
    HelpFaqItem(
      id: 'contracts_payments',
      question: 'How do contracts and payments work?',
      answer:
          'After messaging, create a contract for the engagement. Members '
          'pay through RSRVD; funds are held and released according to project '
          'completion and platform rules.',
    ),
    HelpFaqItem(
      id: 'manage_projects',
      question: 'How do I manage my projects?',
      answer:
          'Open the Projects tab to track Active, On Hold, Held, Issue Raised, '
          'and Completed work. Post updates, chat with the member, and manage '
          'milestones from Project Detail.',
    ),
    HelpFaqItem(
      id: 'receive_payment',
      question: 'When and how do I receive payment?',
      answer:
          'Payment is released after the engagement is completed and any hold '
          'or dispute conditions clear. Payouts are processed through RSRVD’s '
          'payment partners to your linked account.',
    ),
  ];

  void goBack() => Get.back();

  void toggleFaq(String id) {
    expandedId.value = expandedId.value == id ? '' : id;
  }

  void chatWithSupport() {
    if (Get.isRegistered<MainShellController>()) {
      Get.until((route) => Get.currentRoute == AppRoutes.home);
      Get.find<MainShellController>().selectTab(MainTab.chats.index);
      return;
    }
    Get.offAllNamed(AppRoutes.home);
  }

  void emailSupport() => AppFlash.info('support@rsrvd.private');
}

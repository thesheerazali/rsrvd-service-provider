import 'package:get/get.dart';

import '../../core/models/partner_uploaded_document.dart';
import '../../core/services/app_flash.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/user_repository.dart';

/// Settings → Documents — same uploaded-doc cards as Partner Application.
class DocumentsController extends GetxController {
  DocumentsController({UserRepository? userRepository})
      : _users = userRepository ?? Get.find<UserRepository>();

  final UserRepository _users;
  static const String _tag = 'DOCUMENTS';

  final documents = <PartnerUploadedDocument>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    final fromDraft = _users.partnerApplication?.documents ?? const [];
    if (fromDraft.isNotEmpty) {
      documents.assignAll(fromDraft);
      return;
    }
    // UI-base demo — Figma Settings Documents.
    final uploadedAt = DateTime(2026, 8, 8);
    documents.assignAll([
      PartnerUploadedDocument(
        id: 'doc_gov_1',
        fileName: 'government_id_1.pdf',
        docType: 'Government ID',
        uploadedAt: uploadedAt,
      ),
      PartnerUploadedDocument(
        id: 'doc_gov_2',
        fileName: 'government_id_1.pdf',
        docType: 'Government ID',
        uploadedAt: uploadedAt,
      ),
      PartnerUploadedDocument(
        id: 'doc_gov_3',
        fileName: 'government_id_1.pdf',
        docType: 'Government ID',
        uploadedAt: uploadedAt,
      ),
    ]);
  }

  void goBack() => Get.back();

  void retryDocument(String id) {
    AppLog.i('retryDocument id=$id', tag: _tag);
    AppFlash.info('coming_soon'.tr);
  }

  void removeDocument(String id) {
    documents.removeWhere((d) => d.id == id);
    AppLog.i('removeDocument id=$id', tag: _tag);
  }
}

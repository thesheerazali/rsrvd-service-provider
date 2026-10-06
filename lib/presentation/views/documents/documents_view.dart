import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../getx/documents/documents_controller.dart';
import '../../widgets/app_back_title_header.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_uploaded_doc_card.dart';

/// Settings → Documents — Figma Partner docs list.
class DocumentsView extends GetView<DocumentsController> {
  const DocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        glowStyle: AppGlowStyle.home,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppBackTitleHeader(
                title: 'settings_documents'.tr,
                onBack: controller.goBack,
              ),
              Expanded(
                child: Obx(() {
                  final docs = controller.documents.toList();
                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No documents uploaded',
                        style: GoogleFonts.darkerGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize: context.dw(18),
                          color: AppColors.text.withValues(alpha: 0.5),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      context.dw(AppSpacing.t30),
                      context.dw(AppSpacing.t20),
                      context.dw(AppSpacing.t30),
                      context.dw(AppSpacing.t40),
                    ),
                    itemCount: docs.length,
                    separatorBuilder: (_, _) =>
                        SizedBox(height: context.dw(AppSpacing.t10)),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return AppUploadedDocCard(
                        iconColor: AppColors.primary,
                        textColor: AppColors.white,
                        document: doc,
                        onRetry: () => controller.retryDocument(doc.id),
                        onDelete: () => controller.removeDocument(doc.id),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


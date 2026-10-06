import 'package:get/get.dart';

import '../../core/models/partner_review.dart';
import '../../core/services/app_log.dart';
import '../../data/repositories/reviews_repository.dart';

class ReviewsController extends GetxController {
  ReviewsController({ReviewsRepository? repository})
      : _repository = repository ?? Get.find<ReviewsRepository>();

  final ReviewsRepository _repository;
  static const String _tag = 'REVIEWS';

  final isLoading = true.obs;
  final averageLabel = ''.obs;
  final countLabel = ''.obs;
  final reviews = <PartnerReview>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final feed = await _repository.fetchReviews();
      averageLabel.value = feed.averageLabel;
      countLabel.value = feed.countLabel;
      reviews.assignAll(feed.reviews);
    } catch (e, st) {
      AppLog.e('load failed: $e', tag: _tag, error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() => Get.back();
}

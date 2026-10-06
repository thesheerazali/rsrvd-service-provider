import 'package:get/get.dart';

import '../../core/models/partner_review.dart';
import '../../core/services/app_log.dart';

/// Partner Rating & Reviews — Figma `1196:3579`.
class ReviewsRepository extends GetxService {
  static const String _tag = 'REVIEWS_REPO';

  Future<PartnerReviewsFeed> fetchReviews() async {
    AppLog.i('fetchReviews', tag: _tag);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    return PartnerReviewsFeed(
      averageRating: 4.9,
      reviewCount: 24,
      reviews: _demoReviews
          .map(PartnerReview.fromJson)
          .toList(growable: false),
    );
  }

  static const _demoReviews = [
    {
      'id': 'rev_ines',
      'category': 'Architect',
      'rating': 5.0,
      'body':
          'Answered every question before it was asked. The drawings arrived '
          'ahead of schedule and the site team was faultless.',
      'author_name': 'Ines Halvorsen',
      'date_label': 'Mar 25',
    },
    {
      'id': 'rev_sara',
      'category': 'Architect',
      'rating': 4.8,
      'body':
          'Showed great attention to detail and went above and beyond to '
          'ensure client satisfaction.',
      'author_name': 'Sara Lee',
      'date_label': 'May 15',
    },
    {
      'id': 'rev_michael',
      'category': 'Architect',
      'rating': 4.2,
      'body':
          'Maintained a steady pace and delivered quality work, though some '
          'adjustments were needed along the way.',
      'author_name': 'Michael Chen',
      'date_label': 'Jun 30',
    },
    {
      'id': 'rev_ines_2',
      'category': 'Architect',
      'rating': 5.0,
      'body':
          'Answered every question before it was asked. The drawings arrived '
          'ahead of schedule and the site team was faultless.',
      'author_name': 'Ines Halvorsen',
      'date_label': 'Mar 25',
    },
    {
      'id': 'rev_sara_2',
      'category': 'Architect',
      'rating': 4.8,
      'body':
          'Showed great attention to detail and went above and beyond to '
          'ensure client satisfaction.',
      'author_name': 'Sara Lee',
      'date_label': 'May 15',
    },
    {
      'id': 'rev_michael_2',
      'category': 'Architect',
      'rating': 4.2,
      'body':
          'Maintained a steady pace and delivered quality work, though some '
          'adjustments were needed along the way.',
      'author_name': 'Michael Chen',
      'date_label': 'Jun 30',
    },
  ];
}

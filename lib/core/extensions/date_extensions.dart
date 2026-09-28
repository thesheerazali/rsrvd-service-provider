import 'package:get/get.dart';
import 'package:intl/intl.dart';

final _date = DateFormat('dd MMM, yyyy');
final _onlyTime = DateFormat('h:mm a');
final _dayOnly = DateFormat('EEEE');
final _weekdayShort = DateFormat('EEE');
final _monthShort = DateFormat('MMM');
final _dayMonthShort = DateFormat('dd MMM');

extension DateX on DateTime {
  DateTime get today => DateTime(year, month, day);

  String get greeting {
    if (hour < 12) return 'good_morning'.tr;
    if (hour < 17) return 'good_afternoon'.tr;
    if (hour < 21) return 'good_evening'.tr;
    return 'good_night'.tr;
  }

  DateTime get endOfDay => today.add(const Duration(days: 1));

  String get onlyTime => _onlyTime.format(this).toUpperCase();
  String get dayOnly => _dayOnly.format(this).toUpperCase();
  String get weekdayLong => _dayOnly.format(this);
  String get weekdayShort => _weekdayShort.format(this).toUpperCase();
  String get monthShort => _monthShort.format(this);
  String get dayMonthShort => _dayMonthShort.format(this);
  String get date => _date.format(this);

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.today.difference(today);

    if (diff.inDays <= 0) return 'today'.tr;
    if (diff.inDays == 1) return 'yesterday'.tr;
    if (diff.inDays < 7) {
      return 'days_ago'.trParams({'count': '${diff.inDays}'});
    }
    if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return 'weeks_ago'.trParams({'count': '$weeks'});
    }
    final months = (diff.inDays / 30).floor();
    return 'months_ago'.trParams({'count': '$months'});
  }
}

extension AgeX on DateTime? {
  int get toAge => this == null ? 0 : DateTime.now().year - this!.year;
}

import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

class DateTimeConverter {
  static DateTime getDateTimeFromStamp(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp);
  }

  static String getFormattedDate(DateTime dateTime,
      [String format = 'yyyy-MM-dd – kk:mm']) {
    return DateFormat(format).format(dateTime);
  }

  static String getDateTime({required DateTime startDate}) {
    Duration timeElapsed = DateTime.now().difference(startDate);
    String formattedTimeElapsed = formatDuration(timeElapsed);
    return formattedTimeElapsed;
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String formattedTimeElapsed =
        "${duration.inDays}d $twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    return formattedTimeElapsed;
  }
}

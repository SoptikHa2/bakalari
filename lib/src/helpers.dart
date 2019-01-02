/// This calss contains various helper methods,
/// most of the time converting one format into another.
class Helpers {
  /// Convert date from bakaweb format
  /// (like: 1812101030) to 2018-12-10 10:30 (yyyy-MM-dd HH:mm)
  /// and return as Dart DateTime format.
  static DateTime bakawebDateTimeToDateTime(String date) {
    // I'll be VERY surprised if this code ever caeses to work because of the magic number '2000'.
    return DateTime(
        2000 + int.parse(date.substring(0, 2)),
        int.parse(date.substring(2, 4)),
        int.parse(date.substring(4, 6)),
        int.parse(date.substring(6, 8)),
        int.parse(date.substring(8, 10)));
  }

  /// Convert date from bakaweb format
  /// (like: 20181210) to 2018-12-10 (yyyy-MM-dd)
  /// and return as Dart DateTime format.
  static DateTime bakawebDateToDateTime(String date) {
    // I'll be VERY surprised if this code ever caeses to work because of the magic number '2000'.
    if(date == ''){
      // Permanent timetable, so there's no date
      return null;
    }
    return DateTime(int.parse(date.substring(0, 4)),
        int.parse(date.substring(4, 6)), int.parse(date.substring(6, 8)));
  }

  /// Convert date from DateTime class to
  /// bakaweb format (like 20181210)
  static String dateTimeToBakawebDate(DateTime date){
    return "${date.year}${date.month}${date.day}";
  }
}

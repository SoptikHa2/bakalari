library bakalari.modules;

import 'package:bakalari/src/badResponseError.dart';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

/// This module takes care of getting grades from school system.
/// When enabled, this can get even data that is inaccessible via
/// official means. See `Grade` for structure of returned object.
class GradeModule {
  /// Identifier inside the school system
  String identifier = "znamky";
  Map<String, int> weightsMap;

  /// Somewhen in the future, return list
  /// of grades. This may throw an error if
  /// unsuccessful.
  Future<List<Grade>> getResult(String authKey, Uri schoolAddress) async {
    if (weightsMap == null) await _loadWeightsMap(authKey, schoolAddress);

    var client = http.Client();
    http.Response response;
    try {
      response =
          await client.get(schoolAddress.toString() + "?pm=znamky&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code $response", StackTrace.current);
    }

    var grades = List<Grade>();
    var xmlPayload = xml.parse(response.body);
    for (var gradeSegment in xmlPayload.findAllElements('znamky')) {
      for (var grade in gradeSegment.findElements('znamka')) {
        var subject = grade.findElements('pred').first.text;
        var gradeValue = grade.findElements('znamka').first.text;
        var caption = grade.findElements('caption').first.text;
        var date = grade.findElements('udeleno').first.text;
        var note = grade.findElements('poznamka').first.text;
        var weightText = grade.findElements('ozn').first.text;
        // Weight text is string, it's parsed
        // using different table retrieved from API
        var weight = weightsMap[weightText];

        bool addHalfToGradeValue = gradeValue.endsWith('-');
        var gradeValueNum = double.tryParse(gradeValue.replaceAll('-', ''));
        if (gradeValueNum == null) continue;
        if (addHalfToGradeValue) gradeValueNum += 0.5;

        grades.add(Grade(subject, gradeValueNum, date, caption, note, weight));
      }
    }

    return grades;
  }

  /// Somewhen in the future,
  /// load map of grades and their weights.
  ///
  /// You shouldn't ever need to call this manually,
  /// as this is called silently at every new instance
  /// creation of this module.
  Future<void> _loadWeightsMap(String authKey, Uri schoolAddress) async {
    var client = http.Client();
    http.Response response;
    try {
      response = await client
          .get(schoolAddress.toString() + "?pm=predvidac&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code $response", StackTrace.current);
    }

    var result = Map<String, int>();
    var xmlPayload = xml.parse(response.body);
    for (var weightTypes in xmlPayload.findAllElements('typypru')) {
      for (var weightType in weightTypes.findElements('typ')) {
        var title = weightType.findElements('nazev').first.text;
        var value = int.parse(weightType.findElements('vaha').first.text);
        result[title] = value;
      }
    }
    weightsMap = result;
  }
}

class Grade {
  /// Short subject name (`M`, not `Math`)
  String subject;

  /// Value of the grade (1-5, 1 is best)
  double value;

  /// Date when the grade was written
  DateTime date;

  /// Why did user get this grade
  String caption;

  /// Note from teacher
  String note;

  /// Weight of the grade
  int weight;

  /// Create new grade.
  ///
  /// Bakaweb date format is in format `yyMMddHHmm`.
  Grade(this.subject, this.value, String bakawebDateFormat, this.caption,
      this.note, this.weight) {
    // I'll be VERY surprised if this code ever caeses to work because of the magic number '2000'.
    // If it suddenly breakes, find me (or my family).
    // I bet they'd be surprised to hear from someone because he used my library from year 2018. :)
    // Hell, feel free to email me (see package author info) if you use this code in 2050.
    date = DateTime(
        2000 + int.parse(bakawebDateFormat.substring(0, 2)),
        int.parse(bakawebDateFormat.substring(2, 4)),
        int.parse(bakawebDateFormat.substring(4, 6)),
        int.parse(bakawebDateFormat.substring(6, 8)),
        int.parse(bakawebDateFormat.substring(8, 10)));
  }

  @override
  String toString() {
    return "Grade: $value with weight $weight from $subject, received at $date with title $caption and note $note.";
  }
}

library bakalari.modules.grade;

import 'package:bakalari/definitions.dart';

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
  Future<List<Grade>> getResult(String authKey, String schoolAddress) async {
    if (weightsMap == null) await _loadWeightsMap(authKey, schoolAddress);

    var client = http.Client();
    http.Response response;
    try {
      response =
          await client.get(schoolAddress + "?pm=znamky&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code ${response.statusCode}", StackTrace.current);
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
        if (addHalfToGradeValue && gradeValueNum != null) gradeValueNum += 0.5;

        grades.add(Grade.fromBakawebDate(subject, gradeValue, gradeValueNum, date, caption, note, weight));
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
  Future<void> _loadWeightsMap(String authKey, String schoolAddress) async {
    var client = http.Client();
    http.Response response;
    try {
      response = await client
          .get(schoolAddress + "?pm=predvidac&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code ${response.statusCode}", StackTrace.current);
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
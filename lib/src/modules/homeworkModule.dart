library bakalari.modules.homework;

import 'package:bakalari/src/badResponseError.dart';
import 'package:bakalari/src/helpers.dart';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

/// This module takes care of getting homeworks from school system.
/// See `Homework` for structure of returned object.
class HomeworkModule {
  /// Identifier inside the school system
  String identifier = "ukoly";

  /// Somewhen in the future, return list
  /// of homeworks. This may throw an error if
  /// unsuccessful.
  Future<List<Homework>> getResult(String authKey, Uri schoolAddress) async {
    var client = http.Client();
    http.Response response;
    try {
      response =
          await client.get(schoolAddress.toString() + "?pm=ukoly&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code $response", StackTrace.current);
    }

    var result = List<Homework>();
    var xmlPayload = xml.parse(response.body);
    for (var homework in xmlPayload.findAllElements('ukol')) {
      var hw = Homework();

      hw.status = homework.findElements('status').first.text;
      hw.subjectLong = homework.findElements('predmet').first.text;
      hw.subjectShort = homework.findElements('zkratka').first.text;
      hw.title = homework.findElements('popis').first.text;
      hw.from = Helpers.bakawebDateTimeToDateTime(
          homework.findElements('zadano').first.text);
      hw.to = Helpers.bakawebDateTimeToDateTime(
          homework.findElements('nakdy').first.text);

      result.add(hw);
    }

    return result;
  }
}

class Homework {
  /// Long subject name (`Math`)
  String subjectLong;

  /// Short subject name (`M`)
  String subjectShort;

  DateTime from;
  DateTime to;

  String id;

  String status;

  String title;

  @override
  String toString() {
    return '{$status} [$subjectShort] ($to) - $title';
  }
}

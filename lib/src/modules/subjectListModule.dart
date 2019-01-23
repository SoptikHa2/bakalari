library bakalari.modules.subjectList;

import 'package:bakalari/definitions.dart';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

/// This module takes care of getting homeworks from school system.
/// See `Subject` for structure of returned object.
class SubjectListModule {
  /// Identifier inside the school system
  String identifier = "predmety";

  /// Somewhen in the future, return list
  /// of homeworks. This may throw an error if
  /// unsuccessful.
  Future<List<Subject>> getResult(String authKey, String schoolAddress) async {
    var client = http.Client();
    http.Response response;
    try {
      response = await client
          .get(schoolAddress + "?pm=predmety&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code ${response.statusCode}", StackTrace.current);
    }

    var result = List<Subject>();
    var xmlPayload = xml.parse(response.body);
    for (var subject in xmlPayload.findAllElements('predmet')) {
      var sub = Subject();

      sub.subjectId = subject.findElements('kod_pred').first.text;
      sub.subjectLong = subject.findElements('nazev').first.text;
      sub.subjectShort = subject.findElements('zkratka').first.text;
      sub.teacherEmail = subject.findElements('mailuc').first.text;
      sub.teacherName = subject.findElements('ucitel').first.text;
      sub.teacherPhone = subject.findElements('telefonuc').first.text;
      sub.teacherShort = subject.findElements('zkratkauc').first.text;

      result.add(sub);
    }

    return result;
  }
}
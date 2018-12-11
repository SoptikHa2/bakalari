library bakalari.modules;

import 'package:bakalari/src/badResponseError.dart';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

/// This module takes care of getting grades from school system.
/// When enabled, this can get even data that is inaccessible via
/// official means. See `Grade` for structure of returned object.
class GradeModule{
  /// Identifier inside the school system
  String identifier = "znamky";

  /// Somewhen in the future, return list
  /// of grades. This may throw an error if
  /// unsuccessful.
  Future<List<Grade>> getResult(String authKey, Uri schoolAddress) async {
    var client = http.Client();
    http.Response response;
    try{
      response = await client.get(schoolAddress.toString() + "?pm=znamky&hx=$authKey");
    }finally{
      client.close();
    }

    if(response.statusCode != 200){
      throw BadResponseError("Unexpected status code $response", StackTrace.current);
    }

    var xmlPayload = xml.parse(response.body);
    var gradeElements = xmlPayload.findAllElements('znamky').map((znamky) => znamky.findElements('znamka'));
    var grades = gradeElements.expand((e) => e).map((xmlElement) =>
      new Grade(xmlElement.findElements('pred').first.text,
      int.parse(xmlElement.findElements('znamka').first.text),
      xmlElement.findElements('udeleno').first.text,
      xmlElement.findElements('caption').first.text,
      xmlElement.findElements('poznamka').first.text,
      xmlElement.findElements('ozn').first.text));
    return grades.toList();
  }
}

class Grade{
  /// Short subject name (`M`, not `Math`)
  String subject;
  /// Value of the grade (1-5, 1 is best)
  int value; 
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
  /// Bakaweb weight format is in format `váha - {int}`
  Grade(this.subject, this.value, String bakawebDateFormat, this.caption, this.note, String bakawebWeightFormat){
    // I'll be VERY surprised if this code ever caeses to work because of the magic number '2000'.
    // If it suddenly breakes, find me (or my family).
    // I bet they'd be surprised to hear from someone because he used my library from year 2018. :)
    // Hell, feel free to email me (see package author info) if you use this code in 2050.
    date = DateTime(2000 + int.parse(bakawebDateFormat.substring(0, 2)),
    int.parse(bakawebDateFormat.substring(2, 4)),
    int.parse(bakawebDateFormat.substring(4, 6)),
    int.parse(bakawebDateFormat.substring(6, 8)),
    int.parse(bakawebDateFormat.substring(8, 10)));
    weight = int.parse(bakawebWeightFormat.substring(7));
  }

  @override
  String toString() {
    return "Grade: $value with weight $weight from $subject, received on $date with title $caption and note $note.";
    }
}
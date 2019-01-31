library bakalari.listOfSchools;

import 'package:bakalari/definitions.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class ListOfSchools {
  static Future<List<String>> getListOfCities() async {
    var client = http.Client();
    http.Response response;
    try {
      response =
          await client.get('https://sluzby.bakalari.cz/api/v1/municipality');
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code ${response.statusCode}", StackTrace.current);
    }

    var citites = List<String>();
    var xmlPayload = xml.parse(response.body);
    for (var munInfo in xmlPayload.findAllElements('municipalityInfo')) {
      citites.add(munInfo.findElements('name').first.text);
    }

    return citites;
  }

  static Future<List<School>> getSchoolsInCity(String city) async {
    String encodedCityName = Uri.encodeComponent(city);

    var client = http.Client();
    http.Response response;
    try {
      response = await client.get(
          'https://sluzby.bakalari.cz/api/v1/municipality/$encodedCityName');
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code ${response.statusCode}", StackTrace.current);
    }

    var schools = List<School>();
    var xmlPayload = xml.parse(response.body);
    for (var school in xmlPayload.findAllElements('schoolInfo')) {
      var sch = School();
      sch.name = school.findElements('name').first.text;
      sch.bakawebLink = school.findAllElements('schoolUrl').first.text;
    }

    return schools;
  }
}

/// Package that allows reading data from Czech
/// school system Bakaláři. This unofficial
/// library grants access to data that may be
/// locked in the official app - for example
/// all grades weights.
library bakalari;

import 'package:bakalari/src/badResponseError.dart';
import 'package:bakalari/src/student.dart';
import 'package:bakalari/src/school.dart';
import 'package:bakalari/src/modules/gradeModule.dart';
import 'package:bakalari/src/modules/timetableModule.dart';
import 'package:bakalari/src/modules/privateMessagesModule.dart';
import 'package:bakalari/src/modules/homeworkModule.dart';
import 'package:bakalari/src/modules/subjectListModule.dart';

import 'dart:convert';

// We need XML library to parse server response
import 'package:xml/xml.dart' as xml;
// We need HTTP library to send requests to server
import 'package:http/http.dart' as http;
// We need intl to correctly format date
import 'package:intl/intl.dart' as intl;
// We need cryptographic library to generate authentication tokens
import 'package:pointycastle/pointycastle.dart' as pointycastle;

/// This is the entry point.
/// Use this class to log into school system.
/// This class allows you to fetch data from school system.
/// Do not forget to log in! See `Bakalari.logIn()`.
class Bakalari {
  /// Address of Bakalari system. Has to end with /login.aspx
  Uri _schoolAddress;

  /// Authentication key used to login into Bakalari system.
  /// This key is generated by `Bakalari.logIn()`.
  String _key;

  /// This is student linked to bakaweb account
  /// that last used the `Bakalari.logIn()` method.
  ///
  /// Everything relevant - grades, timetable, PMs, etc
  /// are stored here
  Student _student;
  Student get student => _student;

  /// This is school linked to this `Bakalari` instance.
  /// Once this method is created, school doesn't change.
  School _school;
  School get school => _school;

  /// Bakalari constructor.
  /// Address of school system Bakalari is required.
  /// The address has to end with /login.aspx.
  /// Do not forget to log in! See `Bakalari.logIn()`.
  Bakalari(this._schoolAddress);

  /// Log into Bakalari school system.
  /// After this has successfully completed, you can call other methods.
  /// Be careful, errors will be thrown if something bad happens.
  Future<void> logIn(String username, String password) async {
    var client = http.Client();
    http.Response response;
    try {
      response =
          await client.get(_schoolAddress.toString() + "?gethx=$username");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code $response", StackTrace.current);
    }

    var xmlPayload = xml.parse(response.body);
    var salt = xmlPayload.findAllElements('salt').first.text;
    var ikod = xmlPayload.findAllElements('ikod').first.text;
    var typ = xmlPayload.findAllElements('typ').first.text;

    _generateKey(salt, ikod, typ, username, password);

    await _reloadBaseInfo(_generateAuthToken());
  }

  /// This method reloads school, user, and allowed school modules.
  /// You shouldn't need to call this method at normal circumstances.
  Future<void> _reloadBaseInfo(String authKey) async {
    var client = http.Client();
    http.Response response;
    try {
      response =
          await client.get(_schoolAddress.toString() + "?pm=login&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code $response", StackTrace.current);
    }
    var xmlPayload = xml.parse(response.body);

    _school = new School();
    _school.name = xmlPayload.findAllElements('skola').first.text;
    _school.bakawebVersion = xmlPayload.findAllElements('verze').first.text;
    _school.bakawebLink = _schoolAddress;
    _school.allowedModules = xmlPayload
        .findAllElements('moduly')
        .first
        .text
        .split('*')
        .where((item) => item.isNotEmpty)
        .toList();

    _student = new Student();
    _student.name = xmlPayload.findAllElements('jmeno').first.text;
    _student.schoolClass = xmlPayload.findAllElements('trida').first.text;
    _student.year = int.parse(xmlPayload.findAllElements('rocnik').first.text);
  }

  /// Get grades from school system.
  /// Grades module has to be allowed by your school.
  /// See `Grade` class for more info about output.
  Future<List<Grade>> getGrades() async {
    var module = GradeModule();
    if (!school.allowedModules.contains(module.identifier))
      throw UnsupportedError(
          "Module ${module.identifier} is not allowed by school system.");

    return await module.getResult(_generateAuthToken(), _schoolAddress);
  }

  /// Get timetable from school system.
  /// Timetable has to be allowed by your school.
  /// See `Timetable` class for more info about output.
  Future<Timetable> getTimetable() async {
    var module = TimetableModule();
    if (!school.allowedModules.contains(module.identifier))
      throw UnsupportedError(
          "Module ${module.identifier} is not allowed by school system.");

    return await module.getResult(_generateAuthToken(), _schoolAddress);
  }

  /// Get PMs sent to you this year from school system.
  /// PMs are read-only, there is no way how to compose
  /// messages via this library at the moment.
  ///
  /// **WARNING:** Content of PMs contain unescaped HTML,
  /// which might result in XSS. Always be careful when
  /// you deal with PMs.
  Future<List<PrivateMessage>> getMessages() async {
    var module = PrivateMessagesModule();
    if (!school.allowedModules.contains(module.identifier))
      throw UnsupportedError(
          "Module ${module.identifier} is not allowed by school system.");

    return await module.getResult(_generateAuthToken(), _schoolAddress);
  }

  /// Get homeworks from school system.
  /// Homeworks has to be allowed by your school.
  /// See `Homework` class for more info about output.
  Future<List<Homework>> getHomeworks() async {
    var module = HomeworkModule();
    if (!school.allowedModules.contains(module.identifier))
      throw UnsupportedError(
          "Module ${module.identifier} is not allowed by school system.");

    return await module.getResult(_generateAuthToken(), _schoolAddress);
  }

  /// Get list of subjects from school system.
  /// Subject list has to be allowed by your school.
  /// See `Subject` class for more info about output.
  Future<List<Subject>> getSubjects() async {
    var module = SubjectListModule();
    if (!school.allowedModules.contains(module.identifier))
      throw UnsupportedError(
          "Module ${module.identifier} is not allowed by school system.");

    return await module.getResult(_generateAuthToken(), _schoolAddress);
  }

  /// This generates long-term key. Key generated from this method
  /// is useful for permanent storage, because it's not possible to
  /// get password back from it and the actual authentication token
  /// (which has low lifetime) can be generated from this by method
  /// `_generateAuthToken()`.
  ///
  /// Key is saved to `_key`.
  void _generateKey(
      String salt, String ikod, String typ, String username, String password) {
    var computedSalt = salt + ikod + typ;
    var passw = utf8.encode(computedSalt + password);
    var sha512 = pointycastle.Digest("SHA-512");
    var result = base64.encode(sha512.process(passw));
    _key = "*login*" + username + "*pwd*" + result + "*sgn*ANDR";
  }

  /// This generates short-term authentication key that can be used
  /// to access school system API. Generated key (from `_generateKey`)
  /// is required.
  ///
  /// Input key is loaded from `_key`.
  String _generateAuthToken() {
    var now = DateTime.now();
    var date = intl.DateFormat("yyyyMMdd").format(now);
    var sha512 = pointycastle.Digest("SHA-512");
    var result = sha512.process(utf8.encode(_key + date));
    return base64Url.encode(result);
  }
}

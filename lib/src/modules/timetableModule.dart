library bakalari.modules.timetable;

import 'package:bakalari/src/badResponseError.dart';
import 'package:bakalari/src/helpers.dart';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

import 'package:json_annotation/json_annotation.dart';
part 'timetableModule.g.dart';

/// This class takes care of getting time table from school system.
/// See `Timetable` for structure of return object.
class TimetableModule {
  String identifier = "rozvrh";

  Future<Timetable> getResult(String authKey, Uri schoolAddress) async {
    var client = http.Client();
    http.Response response;
    try {
      response =
          await client.get(schoolAddress.toString() + "?pm=rozvrh&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code $response", StackTrace.current);
    }

    var timetable = Timetable();

    var xmlPayload = xml.parse(response.body);
    var xmlOfTimetable = xmlPayload.findAllElements('rozvrh').first;
    {
      timetable.times = List<LessonTime>();
      timetable.days = List<Day>();
      timetable.currentCycleID =
          xmlOfTimetable.findElements('kodcyklu').first.text;
      timetable.currentCycleCaption =
          xmlOfTimetable.findElements('zkratkacyklu').first.text;
      var lessonTimeRoot = xmlOfTimetable.findAllElements('hodiny').first;
      for (var hod in lessonTimeRoot.findAllElements('hod')) {
        var lt = LessonTime();
        try {
          lt.caption = hod.findElements('caption').first.text;
          lt.beginTime = hod.findElements('begintime').first.text;
          lt.endTime = hod.findElements('endtime').first.text;
          timetable.times.add(lt);
        } catch (e) {
          print(e.stackTrace);
          print(hod.toString());
        }
      }
      for (var day in xmlOfTimetable.findAllElements('den')) {
        var d = Day();
        d.shortName = day.findElements('zkratka').first.text;
        d.date =
            Helpers.bakawebDateToDateTime(day.findElements('datum').first.text);
        d.lessons = List<Lesson>();
        int lessonNumberInDay = 0;
        for (var lesson in day.findAllElements('hod')) {
          var l = Lesson();
          l.type = lesson.findElements('typ').first.text;
          l.lessonTime = timetable.times[lessonNumberInDay];
          lessonNumberInDay++;
          // All following types are optional, so if something
          // bad happens, we can just ignore it
          try {
            l.id = lesson.findElements('idcode').first.text;
            l.change = lesson.findElements('chng').first.text;
            l.classGroupLong = lesson.findElements('skup').first.text;
            l.classGroupShort = lesson.findElements('zkrskup').first.text;
            l.classroom = lesson.findElements('zkrmist').first.text;
            l.subjectLong = lesson.findElements('pr').first.text;
            l.subjectShort = lesson.findElements('zkrpr').first.text;
            l.teacherLong = lesson.findElements('uc').first.text;
            l.teacherShort = lesson.findElements('zkruc').first.text;
            l.lessonContent = lesson.findElements('tema').first.text;
            l.isSet = true;
          } catch (e) {}
          d.lessons.add(l);
        }
        timetable.days.add(d);
      }
    }

    return timetable;
  }
}

/// This is timetable returned from school system.
@JsonSerializable()
class Timetable {
  /// Days in timetable (should be around 5), each
  /// has list of lessons
  List<Day> days;

  /// This lists the lesson times, so one can
  /// easily build table
  List<LessonTime> times;

  /// ID of current (week) cycle
  /// (timetable might differ in different cycles)
  String currentCycleID;

  /// Name of current (week) cycle
  String currentCycleCaption;

  Timetable(
      {this.currentCycleCaption, this.currentCycleID, this.days, this.times});

  factory Timetable.fromJson(Map<String, dynamic> json) =>
      _$TimetableFromJson(json);
  Map<String, dynamic> toJson() => _$TimetableToJson(this);
}

/// This is one day in timetable that encapsulates individual lessons
@JsonSerializable()
class Day {
  List<Lesson> lessons;
  DateTime date;
  String shortName;

  Day({this.date, this.lessons, this.shortName});

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
  Map<String, dynamic> toJson() => _$DayToJson(this);
}

/// This is lesson - teacher, time, etc
///
/// Following fields are declared always:
/// - `String type`
///
/// All other fields can be null, especially
/// if there is empty hour in the timetable.
///
/// Check out artifical `isSet` field to know
/// if the lesson is in the timetable.
@JsonSerializable()
class Lesson {
  /// Type of lesson, one letter code
  String type;

  /// Id of lesson
  String id;

  /// Long name of subject - for example Math
  String subjectLong;

  /// Short name of subject - for example M
  String subjectShort;

  /// Full name and title of teacher
  String teacherLong;

  /// Shortened name of teacher (usually three letters of his surname)
  String teacherShort;

  /// ID of classsroom where the lesson takes place
  String classroom;

  /// What was (will be) done in the lesson
  String lessonContent;

  /// Described change (if any) (for example when moved from classroom 204 to 203)
  String change;

  /// Group of class (if class divides to groups for particular subject)
  String classGroupLong;

  /// The same as `classGroupLong`, but shortcode fro it (usually three letters)
  String classGroupShort;

  LessonTime lessonTime;

  /// This determines if most of the fields here are set. If this is false,
  /// probably there is no lesson sheduled and it makes no sence to try to get
  /// additional info about this lesson.
  bool isSet;

  Lesson(
      {this.type,
      this.teacherLong,
      this.teacherShort,
      this.subjectShort,
      this.subjectLong,
      this.change,
      this.classGroupLong,
      this.classGroupShort,
      this.classroom,
      this.id,
      this.isSet,
      this.lessonContent,
      this.lessonTime});

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}

/// This is time when lesson occurs.
@JsonSerializable()
class LessonTime {
  String caption;
  String beginTime;
  String endTime;

  LessonTime({this.caption, this.beginTime, this.endTime});

  factory LessonTime.fromJson(Map<String, dynamic> json) =>
      _$LessonTimeFromJson(json);
  Map<String, dynamic> toJson() => _$LessonTimeToJson(this);
}

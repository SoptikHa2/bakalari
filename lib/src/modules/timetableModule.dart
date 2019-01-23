library bakalari.modules.timetable;

import 'package:bakalari/definitions.dart';
import 'package:bakalari/src/helpers.dart';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

/// This class takes care of getting time table from school system.
/// See `Timetable` for structure of return object.
class TimetableModule {
  String identifier = "rozvrh";

  /// Get timetable (if school supports the module)
  ///
  /// You can optionally specify source - either `Today`, `Permanent`, or `ByDate`.
  /// If you select `ByDate`, you have to specify `dateSource` (type DateTime).
  Future<Timetable> getResult(String authKey, String schoolAddress,
      {TimetableSource source = TimetableSource.Today,
      DateTime dateSource = null}) async {
    var client = http.Client();
    http.Response response;

    String strSource = "";
    if (source == TimetableSource.Permanent)
      strSource = "&pmd=perm";
    else if (source == TimetableSource.ByDate)
      strSource = "&pmd=${Helpers.dateTimeToBakawebDate(dateSource)}";

    try {
      response = await client
          .get(schoolAddress + "?pm=rozvrh&hx=$authKey" + strSource);
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code ${response.statusCode}", StackTrace.current);
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
        d.lessons = List<List<Lesson>>();
        int lessonNumberInDay = 0;
        String lastLessonCaption = '0';
        for (var lesson in day.findAllElements('hod')) {
          var l = Lesson();
          String lessonCaption = '';
          l.type = lesson.findElements('typ').first.text;
          l.lessonTime = timetable.times[lessonNumberInDay];
          // All following types are optional, so if something
          // bad happens, we can just ignore it
          try {
            lessonCaption = lesson.findElements('caption').first.text;
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

          // If the lesson is type X, or the caption (in all cases I've seen so far: lesson number) is different,
          // we can skip to another time cell in timetable
          if (l.type == 'X' || lessonCaption != lastLessonCaption)
            lessonNumberInDay++;
          lastLessonCaption = lessonCaption;

          if (lessonNumberInDay < d.lessons.length) {
            d.lessons[lessonNumberInDay].add(l);
          } else {
            d.lessons.add([l]);
          }
        }
        timetable.days.add(d);
      }
    }
    return timetable;
  }
}


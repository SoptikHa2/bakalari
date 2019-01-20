import 'package:bakalari/bakalari.dart';
import 'dart:io';

main(List<String> args) {
  print('Dart example of \'bakalari\' library has loaded.');
  print(
      'Enter your school Uri (for example \'bakalari.ceskolipska.cz\'');
  var uri = stdin.readLineSync();
  print('Enter username');
  var username = stdin.readLineSync();
  print('Enter password');
  stdin.echoMode = false;
  var password = stdin.readLineSync();
  stdin.echoMode = true;

  someAsyncFunction(username, password, uri);
}

/// The code accessing bakaweb should be in special async function.
void someAsyncFunction(String username, String password, String uri) async {
  var bkw = Bakalari(uri);
  await bkw.logIn(username, password);
  print(
      'Welcome, student ${bkw.student.name}, class ${bkw.student.schoolClass} (year: ${bkw.student.year})! '
      'This library has successfully connected to ${bkw.school.name} (${bkw.school.bakawebVersion}). '
      'You can visit the official Bakaweb service by clicking on this link: ${bkw.school.bakawebLink}');

  var grades = await bkw.getGrades();
  for (var grade in grades) {
    print(grade);
  }

  var timetable = await bkw.getTimetable();
  var permTimetable = await bkw.getTimetablePermanent();
  print('Timetable is done!');
  print(
      'Use debug mode to inspect it, I didn\'t write toString method because of it\'s complexity.');

  var pms = await bkw.getMessages();
  print('Messages:');
  for (var message in pms) {
    print(message);
  }

  var hws = await bkw.getHomework();
  for (var hw in hws) {
    print(hw);
  }

  var subjects = await bkw.getSubjects();
  for (var subject in subjects) {
    print(subject);
  }

  // Print serialized list of subjects
  print(subjects.map((s) => s.toJson()));
}

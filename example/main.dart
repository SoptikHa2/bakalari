import 'package:bakalari/bakalari.dart';
import 'dart:io';

main(List<String> args) {
  print('Dart example of \'bakalari\' library has loaded.');
  print(
      'Enter your school Uri (*has* to end with /login.aspx/! Library doesn\'t fix wrong format.)');
  var uri = stdin.readLineSync();
  print('Enter username');
  var username = stdin.readLineSync();
  print('Enter password');
  var password = stdin.readLineSync();
  someAsyncFunction(username, password, uri);
}

/// The code accessing bakaweb should be in special async function.
void someAsyncFunction(String username, String password, String uri) async {
  var bkw = Bakalari(Uri.parse(uri));
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
  print('Timetable is done!');
  print(
      'Use debug mode to inspect it, I didn\'t write toString method because of it\'s complexity.');

  var pms = await bkw.getMessages();
  print('Messages:');
  for (var message in pms) {
    print(message);
  }

  var hws = await bkw.getHomeworks();
  for (var hw in hws) {
    print(hw);
  }

  var subjects = await bkw.getSubjects();
  for (var subject in subjects) {
    print(subject);
  }
}

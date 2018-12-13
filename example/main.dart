import 'package:bakalari/bakalari.dart';
import 'dart:io';

main(List<String> args) {
  print('Dart example of \'bakalari\' library has loaded.');
  print('Enter your school Uri (*has* to end with /login.aspx/)');
  var uri = stdin.readLineSync();
  print('Enter username');
  var username = stdin.readLineSync();
  print('Enter password');
  var password = stdin.readLineSync();
  someAsyncFunction(username, password, uri);
}

void someAsyncFunction(String username, String password, String uri) async{
  var bkw = Bakalari(Uri.parse(uri));
  await bkw.logIn(username, password);
  var grades = await bkw.getGrades();
  for (var grade in grades) {
    print(grade);
  }
}
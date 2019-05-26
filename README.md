# Bakaláři
Bakaláři is Dart library that can be used for accessing Bakaweb API. Bakaláři (Bakaweb) is Czech school system. This library allows gathering information like grades, timetable, PMs, or homework.

This library is directly based on [vakabus/pybakalib](https://github.com/vakabus/pybakalib/).

If you are at GitHub, the package can be found at [pub.dartlang.org](https://pub.dartlang.org/packages/bakalari).

## Install
Open `pubspec.yaml` of your project and insert following line into dependencies section:
```
bakalari: ^0.3.3
```
Run `pub get` and it should install automatically.

## Use
Into `main.dart`, insert this line:
```dart
import 'package:bakalari/bakalari.dart';
```

Create some async method. Instantiate `Bakalari` class and **don't forget to log in** (`.logIn()`).
Now, you can call methods like `.getGrades()` on the instance.

There are two static methods that can be called without instantiating the library: `getListOfCitites` which returns list of cities in which is at least one school using the Bakaláři system, and `getListOfSchools`, which returns list of schools using the Bakáláři system in a city.

See [example/main.dart](https://github.com/SoptikHa2/bakalari/blob/master/example/main.dart) for example code.

If you run into problems, [create GitHub issue](https://github.com/SoptikHa2/bakalari/issues) and I'll get into it as soon as possible.

# Other community projects

- [pybakalib](https://github.com/vakabus/pybakalib/) is python library that powers the alternative Bakaweb website, [Bakaweb.tk](https://www.bakaweb.tk/).
- [bakalari-api](https://github.com/bakalari-api/bakalari-api) is unofficial documentation of Bakaweb API. Apart from documentation, this organization provides some unofficial apps that use the Bakaweb API.

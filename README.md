# Bakaláři
Bakaláři is Dart library that can be used for accessing Bakaweb API. Bakaláři (Bakaweb) is Czech school system. This library allows gathering information like marks, or subject average.

This library is directly based on [vakabus/pybakalib](https://github.com/vakabus/pybakalib/).

For additional technical informations, see [doc/how_it_works.md](https://github.com/SoptikHa2/bakalari/blob/master/doc/how_it_works.md).

## Install
Open `pubspec.yaml` of your project and into dependencies, insert following line:
```
bakalari: ^0.1.0
```
Run `pub get` and it should install automagically.

Following dependencies will be installed:
```
dependencies:
        http: ^0.12.0
        xml: ^3.2.3
        intl: ^0.15.7
        pointycastle: ^1.0.0-rc4
```

## Use
Into `main.dart`, insert this line:
```dart
import 'package:bakalari/bakalari.dart';
```

Create some async method. Instantiate `Bakalari` class and **don't forget to log in**.
Now, you can call `.getGrades()`, `.getMessages()` and `.getTimetable()` on the instance.

See [example/main.dart](https://github.com/SoptikHa2/bakalari/blob/master/example/main.dart) for example code.

If you run into any problems, [create GitHub issue](https://github.com/SoptikHa2/bakalari/issues) and I'll get into it as soon as possible.
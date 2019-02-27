## Version 0.3.1
Updated dependencies.

Fixed issues with querying cities which names contain a dot.

## Version 0.3.0
Moved all class definitions into `lib/definitions.dart`, so it can be
easily imported and used.

Removed school URI fix, as it broke more things than solved - schools do not have
any uniform bakaweb address style. Thankfully, there is API endpoint
that can be used to find corresponding school address.

So now, you can use this library to get list of citites and schools in these cities - much like in
the Bakalari smartphone app.

### Version 0.2.3
Updated dependencies and removed obsolate method.

Library now tries to fix provided school URI itself.
It takes the domain and converts it to `https://example.com/login.aspx`.
Scheme is forced as https.

Let me know if there are any issues with this, and I'll add option to override it
or change the URI fix.

### Version 0.2.2
Fixed spelling. Login failure will throw useful explanation.

### Version 0.2.1
Library now internally fetches timetable for the next week if it's weekend - so for example, on Saturday, week 1, you'll already see timetable for week 2.

### Version 0.2.0
Minor fix

### Version 0.1.9
Timetable serialization hotfix

### Version 0.1.8
Fixed permanent timetable. Each timetable may now contain more 
lessons in one time-spot.

Updated pointycastle package.

### Version 0.1.7
Added option to specify timetable date

### Version 0.1.4, 0.1.5, 0.1.6
Serialization hotfix

### Version 0.1.3
Added serialization support ([json_serializable](https://pub.dartlang.org/packages/json_serializable))

### Version 0.1.2
Added homework module and subject list module.

### Version 0.1.1
Fixed issues with format. Shortened package description.

## Version 0.1.0
First release.

Package features grades, timetable, PMs, and basic info about student and school.

Package is published on github ([/SoptikHa2/bakalari](https://github.com/SoptikHa2/bakalari)).
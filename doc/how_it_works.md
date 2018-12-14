# How does this work?
School system Bakaláři offers hidden API. You can use this library to connect to the API and fetch data from it.

We communicate with the API by sending `GET` requests with query strings.
## Logging in
First of all, we fetch `GET bakalari.example.com/login.aspx` with querystring `gethx={username}`.

Here is example result:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<results>
    <res>07</res>
    <typ>C</typ>
    <ikod>A2C2Q</ikod>
    <salt>D238</salt>
    <pheslo></pheslo>
</results>
```

With this info, we can generate auth code from combination of information received from server and user password.

Auth key generation is implemented in `/lib/src/bakalari.dart` in `_generateKey()` and `_generateAuthToken()`.

## Getting list of available modules
We send `GET` request to the school system (page `/login.aspx/`), with query string `pm=login` (so we get the modules list) and `hx=authKey`.

Xml is returned, one xml node has list of modules, separated by `*`.

## Grades
We send `GET` request to the school system (page `/login.aspx/`), with query string `pm=znamky` and `hx=authKey`.

Xml is returned, it has all student's grades from this year. Grade weight is stored in field `ozn`, where is weight identifier (type of grade). We can get the exact numeric weight by querying `pm=predvidac` (the same way as before), which has list of weight identifiers and the numerical weight values.

## Time table
We send `GET` request as usual, `pm=rozvrh` and `hx=authKey`.

The structure contains days, lesson hours, and the actual lessons data. The format in which this library outputs the timetable might be a little confusing.

In timetable, you can see `times` - in there, it's declared when each lessons starts and ends. This doesn't mean a lesson is sheduled on this time. This is there to help you with visual format creation.

Timetable offers you to access `days` - Each day consists of the actual lessons. The lessons have
`isSet` attribute. If it's set to `true`, the lesson is there and you can check out additional fields. If it's `false`, there is probably no lesson in given timeframe and it makes no sence to
check additional fields.

Apart from many other fields, each lesson has reference to lessontime - it's reference to the same object as is in the `timetable.times` field.

## PMs
Private messages can be received just like everything else. Actually writing, or confirming PMs as read is not supported.

We send `GET` request as usual, `pm=prijate` and `hx=authkey`.

Structure is pretty simple, there is no need to describe it here.

## Homeworks
Homeworks can be fetched from server. They might include some attachments, but one need to be logged into Bakaweb service to actually download them.

We send `GET` request as usual, `pm=ukoly` and `hx=authkey`.

## Subject list
list of subjects can be fetched from server.

We send `GET` request as usual, `pm=predmety` and `hx=authkey`.
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
We send `GET` request as usual, `pm=rozvrh`.

Xml is returned, it describes 
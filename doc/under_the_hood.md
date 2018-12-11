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
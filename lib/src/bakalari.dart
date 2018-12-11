library bakalari.core;

import 'package:bakalari/src/badResponseError.dart';
import 'dart:convert';
// We need XML library to parse server response
import 'package:xml/xml.dart' as xml;
// We need HTTP library to send requests to server
import 'package:http/http.dart' as http;
// We need intl to correctly format date
import 'package:intl/intl.dart' as intl;
// We need cryptographic library to generate authentication tokens
// TODO: Import PointyCastle

/// This is the entry point.
/// Use this class to log into school system.
/// This class allows you to fetch data from school system.
/// Do not forget to log in! See `Bakalari.logIn()`.
class Bakalari{
  /// Address of Bakalari system. Has to end with /login.aspx
  Uri _schoolAddress;
  /// Authentication key used to login into Bakalari system.
  /// This key is generated by `Bakalari.logIn()`.
  String _key;


  /// Bakalari constructor.
  /// Address of school system Bakalari is required.
  /// The address has to end with /login.aspx.
  /// Do not forget to log in! See `Bakalari.logIn()`.
  Bakalari(this._schoolAddress);

  /// Log into Bakalari school system.
  /// After this has completed, you can call other methods.
  /// Be careful, errors will be thrown if something bad happens.
  Future<void> logIn(String username, String password) async{
    // First of all, let's get some values needed to craft auth string
    _schoolAddress.replace(queryParameters: {
      "gethx" : username
    });
    var response = await http.get(_schoolAddress);
    if(response.statusCode != 200){
      throw BadResponseError("Unexpected status code $response", StackTrace.current);
    }

    var xmlPayload = xml.parse(response.body);
    var salt = xmlPayload.findAllElements('salt').first.text;
    var ikod = xmlPayload.findAllElements('ikod').first.text;
    var typ = xmlPayload.findAllElements('typ').first.text;
  
    _generateKey(salt, ikod, typ, username, password);
  }

  /// This generates long-term key. Key generated from this method
  /// is useful for permanent storage, because it's not possible to
  /// get password back from it and the actual authentication token
  /// (which has low lifetime) can be generated from this by method
  /// `_generateAuthToken()`.
  /// 
  /// Key is saved to `_key`.
  void _generateKey(String salt, String ikod, String typ, String username, String password){
    var computedSalt = salt + ikod + typ;

    
    var passw = utf8.encode(salt + password);
    var sha512 = Digest("SHA-512");
    var result = sha512.process(passw);
    _key = "*login*" + username + "*pwd*" + utf8.decode(result) + "*sgn*ANDR";
  }

  /// This generates short-term authentication key that can be used
  /// to access school system API. Generated key (from `_generateKey`)
  /// is required.
  /// 
  /// Input key is loaded from `_key`.
  String _generateAuthToken(){
    var now = DateTime.now();
    var date = intl.DateFormat("yyyy-MM-dd").format(now);
    var sha512 = Digest("SHA-512");
    var result = sha512.process(utf8.encode(_key + date));
    return utf8.decode(result);
  }
}
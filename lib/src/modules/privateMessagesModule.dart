library bakalari.modules.privateMessages;

import 'package:bakalari/definitions.dart';
import 'package:bakalari/src/helpers.dart';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;


/// This module takes care of getting PMs from school system.
/// See `PrivateMessage` for structure of returned object.
class PrivateMessagesModule {
  /// Identifier inside the school system
  String identifier = "prijate";

  /// Somewhen in the future, return list
  /// of grades. This may throw an error if
  /// unsuccessful.
  Future<List<PrivateMessage>> getResult(
      String authKey, String schoolAddress) async {
    var client = http.Client();
    http.Response response;
    try {
      response = await client
          .get(schoolAddress + "?pm=prijate&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code ${response.statusCode}", StackTrace.current);
    }

    var pms = List<PrivateMessage>();
    var xmlPayload = xml.parse(response.body);
    for (var message in xmlPayload.findAllElements('zprava')) {
      var id = message.findElements('id').first.text;
      var title = message.findElements('nadpis').first.text;
      var dateTime = message.findElements('cas').first.text;
      var sender = message.findElements('od').first.text;
      var type = message.findElements('druh').first.text;
      var content = message.findElements('text').first.text;
      // Remove CDATA declaration from `content`
      content = content.replaceFirst('<![CDATA[', '');
      content.substring(
          0, content.length - 3); // Remove ]]> from end of message
      pms.add(PrivateMessage.fromBakawebDateTime(
          id, content, title, sender, type, dateTime));
    }

    return pms;
  }
}
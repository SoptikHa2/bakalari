library bakalari.modules.privateMessages;

import 'package:bakalari/src/badResponseError.dart';
import 'package:bakalari/src/helpers.dart';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

/// This module takes care of getting grades from school system.
/// When enabled, this can get even data that is inaccessible via
/// official means. See `Grade` for structure of returned object.
class PrivateMessagesModule {
  /// Identifier inside the school system
  String identifier = "prijate";

  /// Somewhen in the future, return list
  /// of grades. This may throw an error if
  /// unsuccessful.
  Future<List<PrivateMessage>> getResult(String authKey, Uri schoolAddress) async {
    var client = http.Client();
    http.Response response;
    try {
      response =
          await client.get(schoolAddress.toString() + "?pm=prijate&hx=$authKey");
    } finally {
      client.close();
    }

    if (response.statusCode != 200) {
      throw BadResponseError(
          "Unexpected status code $response", StackTrace.current);
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
      content.substring(0, content.length-3); // Remove ]]> from end of message
      pms.add(PrivateMessage(id, content, title, sender, type, dateTime));
    }

    return pms;
  }
}

class PrivateMessage {
  /// Id of the private message
  String id;
  /// # Potential vulnerability
  /// 
  /// Content of private message.
  /// 
  /// WARNING: UNESCAPED HTML
  /// 
  /// WARNING: POTENTIAL XSS VULNERABILITY
  /// 
  /// **ALWAYS** be careful about whatever you do
  /// with this.
  String content;
  /// Title of the message. It's empty most of the time,
  /// if not always. Do not rely on this.
  String title;
  /// Name of sender
  String senderName;
  /// DateTime sent
  DateTime dateTime;
  /// Type of message
  String type;

  PrivateMessage(this.id, this.content, this.title, this.senderName, this.type, String dateTime){
    this.dateTime = Helpers.bakawebDateTimeToDateTime(dateTime);
  }

  @override
    String toString() {
      return 'Received a message from $senderName at $dateTime, here\'s the content: $content';
    }
}

import 'package:flutter/cupertino.dart';
import 'package:radauon/modules/chat_detail_page.dart';

class ChatMessage {
  String message;
  MessageType type;
  ChatMessage({@required this.message, @required this.type});
}

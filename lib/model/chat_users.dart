import 'package:flutter/cupertino.dart';

class ChatUsers {
  String text;
  String secondaryText;
  String image;
  String time;
  String count;
  ChatUsers(
      {@required this.text,
      @required this.secondaryText,
      @required this.image,
      @required this.time,
      this.count});
}

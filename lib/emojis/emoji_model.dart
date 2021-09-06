import 'dart:io';

class Emoji {
  /// emoji for the emoji
  String emoji;

  /// Description for the emoji
  String description;

  Emoji(this.emoji, this.description);

  Emoji.fromJson(Map<String, String> json) {
    emoji = json['emoji'];
    description = json['description'];
  }

  static List<Emoji> emojiListFromJson(List<Map<String, String>> json) {
    return json.map((e) => Emoji.fromJson(e)).toList();
  }
}

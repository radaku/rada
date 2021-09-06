class ForumModel {
  int id;
  String message;
  String sender_id;
  String sender_name;
  String size;
  String student_avata;
  String filename;
  String thumb;
  String title;
  String url;
  String type;
  String imagename;
  String status;
  String reply;
  String caption;
  String channel;
  String created_at;
  String time;

  ForumModel(
      {this.id,
      this.message,
      this.sender_id,
      this.sender_name,
      this.size,
      this.student_avata,
      this.filename,
      this.thumb,
      this.title,
      this.url,
      this.type,
      this.imagename,
      this.status,
      this.reply,
      this.caption,
      this.channel,
      this.created_at,
      this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'sender_id': sender_id,
      'sender_name': sender_name,
      'size': size,
      'student_avata': student_avata,
      'filename': filename,
      'thumb': thumb,
      'url': url,
      'title': title,
      'type': type,
      'imagename': imagename,
      'status': status,
      'reply': reply,
      'caption': caption,
      'channel': channel,
      'created_at': created_at,
      'time': time,
    };
  }

  ForumModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
    sender_id = map['sender_id'];
    sender_name = map['sender_name'];
    size = map['size'].toString();
    student_avata = map['student_avata'];
    filename = map['filename'];
    thumb = map['thumb'];
    url = map['url'].toString();
    title = map['title'];
    type = map['type'];
    imagename = map['imagename'];
    status = map['status'];
    reply = map['reply'];
    caption = map['caption'];
    channel = map['channel'];
    created_at = map['created_at'];
    time = map['time'];
  }
}

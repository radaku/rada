class Messages {
  int id;
  String name;
  String message;
  String sender;
  String date;
  String time;
  String avata;
  String type;
  String url;
  String reply;
  String mentor;
  String created_at;

  Messages({this.id, this.name,this.message,this.sender,this.date,this.time,this.avata,this.type,this.url,this.reply,this.mentor,this.created_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'message':message,
      'sender':sender,
      'date':date,
      'time':time,
      'avata':avata,
      'type':type,
      'url':url,
      'reply':reply,
      'mentor':mentor,
      'created_at': created_at,
    };
  }


  Messages.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    message=map['message'];
    sender=map['sender'];
    date=map['date'];
    time=map['time'];
    avata=map['avata'];
    type=map['type'];
    url=map['url'];
    reply=map['reply'];
    mentor=map['mentor'];
    created_at = map['created_at'].toString();
  }

}
class Recordings {
  int id;
  String name;
  String url;
  String duration;
  String date;
  String time;
  String type;
  String created_at;

  Recordings(
      {this.id,
      this.name,
      this.url,
      this.duration,
      this.date,
      this.time,
      this.type,
      this.created_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'duration': duration,
      'created_at': created_at,
    };
  }

  /*Recordings.fromMap(Map<String, dynamic> map, this.id, this.name, this.url, this.created_at) {
    id = map['id'];
    name = map['name'];
    url = map['url'];
    created_at = map['created_at'];
  }*/

  Recordings.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    url = map['url'];
    duration = map['duration'];
    created_at = map['created_at'].toString();
  }
}

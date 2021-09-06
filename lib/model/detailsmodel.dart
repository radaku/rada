class DetailsModel {
  int id;
  String name;
  String user_id;
  String user_type;
  String synced;
  String created_at;

  DetailsModel({this.id, this.user_id,this.user_type,
    this.synced,
    this.created_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user_id':user_id,
      'user_type':user_type,
      'synced':synced,
      'created_at': created_at,
    };
  }


  DetailsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    user_id=map['user_id'];
    user_type = map['user_type'];
    synced=map['synced'];
    created_at = map['created_at'].toString();
  }

}
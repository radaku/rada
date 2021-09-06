import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radauon/model/forummodel.dart';
import 'package:sqflite/sqflite.dart';

class ForumHelper {
  static final _dbName = "radaforum.db";
  static final _dbVersion = 1;
  static final _tableName = "forum_messages";
  static final id = "id";
  static final message = "message";
  static final sender_id = "sender_id";
  static final sender_name = "sender_name";
  static final size = "size";
  static final student_avata = "student_avata";
  static final filename = "filename";
  static final thumb = "thumb";
  static final url = "url";
  static final title = "title";
  static final type = "type";
  static final imagename = "imagename";
  static final status = "status";
  static final reply = "reply";
  static final caption = "caption";
  static final channel = "channel";
  static final created_at = "created_at";
  static final time = "time";

  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'messages';
  static const String DB_NAME = 'messagesdb.db';

  List data_list = [];

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE (
        $id INTEGER,
        $message TEXT,
        $sender_id TEXT,
        $sender_name TEXT,
        $size TEXT,
        $student_avata TEXT,
        $filename TEXT,
        $thumb TEXT,
        $url TEXT,
        $title TEXT,
        $type TEXT,
        $imagename TEXT,
        $status TEXT,
        $reply TEXT,
        $caption TEXT,
        $channel TEXT,
        $created_at TEXT,
        $time TEXT PRIMARY KEY
      )
      ''');
  }

  Future<int> save(Map<String, dynamic> data) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, data);
  }

  Future<List<ForumModel>> getMessages() async {
    var dbClient = await db;
    int limit = 150;
    List<Map> maps = await dbClient
        .rawQuery("SELECT * FROM $TABLE ORDER BY $id ASC LIMIT $limit");
    List<ForumModel> recordings = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordings.add(ForumModel.fromMap(maps[i]));
      }
    }
    return recordings;
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.delete(TABLE);
  }

  /*Future<int> delete(String time) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$time = ?', whereArgs: [time]);
  }*/

  Future<int> delete(String time) async {
    var dbClient = await db;
    await dbClient.rawQuery('DELETE FROM $TABLE WHERE time=$time');
    return 1;
  }

  Future<int> update(ForumModel messages) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, messages.toMap(),
        where: '$id = ?', whereArgs: [messages.id]);
  }

  /*Future<int> update(Map reproductive) async {
    var dbClient = await db;

    return await dbClient.update(TABLE, reproductive,);
  }*/

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}

import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:radauon/model/messages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {


  static final _dbName="rada.db";
  static final _dbVersion=2;
  static final _tableName="mentormessages";
  static final id="id";
  static final name="name";
  static final message="message";
  static final sender="sender";
  static final date="date";
  static final time="time";
  static final avata="avata";
  static final type="type";
  static final mentor="mentor";
  static final url="url";
  static final reply="reply";
  static final messagedate="created_at";


  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'mentormessages';
  static const String DB_NAME = 'radadb.db';

  List data_list=[];

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
    await db.execute(
        '''
      CREATE TABLE $TABLE (
        $id INTEGER,
        $name TEXT NOT NULL,
        $message TEXT NOT NULL,
        $sender TEXT NOT NULL,
        $date TEXT NOT NULL,
        $time TEXT NOT NULL,
        $avata TEXT,
        $type TEXT NOT NULL,
        $mentor TEXT NOT NULL,
        $url TEXT,
        $reply TEXT,
        $messagedate TEXT PRIMARY KEY
      )
      '''
    );
  }


  Future<int> save(Map<String,dynamic> data) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, data);
  }

  Future<List<Messages>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE ORDER BY $id ASC");
    List<Messages> recordings = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordings.add(Messages.fromMap(maps[i]));
      }
    }
    return recordings;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$id = ?', whereArgs: [id]);
  }

  Future<int> update(Messages recordings) async {
    var dbClient = await db;
    // return await dbClient.update(TABLE, recordings.toMap(),
    //     where: '$ID = ?', whereArgs: [recordings.id]);
    return await dbClient.update(TABLE, recordings.toMap(),
        where: '$id = ?', whereArgs: [recordings.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}
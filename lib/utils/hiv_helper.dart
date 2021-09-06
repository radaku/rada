import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:radauon/model/hivmodel.dart';
import 'package:radauon/model/messages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class HivHelper {


  static final _dbName="rada.db";
  static final _dbVersion=2;
  static final _tableName="mentormessages";
  static final id="id";
  static final name="name";
  static final kenyahiv="kenyahiv";
  static final definition="definition";
  static final hivsymptoms="hivsymptoms";
  static final transmissionmodes="transmissionmodes";
  static final nottransmitted="nottransmitted";
  static final hivmyths="hivmyths";
  static final hivprevention="hivprevention";
  static final mothertochild="mothertochild";
  static final hivstigma="hivstigma";
  static final created_at="created_at";


  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'hiv';
  static const String DB_NAME = 'hivdb.db';

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
        $name TEXT,
        $kenyahiv TEXT,
        $definition TEXT,
        $hivsymptoms TEXT,
        $transmissionmodes TEXT,
        $nottransmitted TEXT,
        $hivmyths TEXT,
        $hivprevention TEXT,
        $mothertochild TEXT,
        $hivstigma TEXT,
        $created_at TEXT PRIMARY KEY
      )
      '''
    );
  }


  Future<int> save(Map<String,dynamic> data) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, data);
  }

  Future<List<HivModel>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE ORDER BY $id ASC");
    List<HivModel> recordings = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordings.add(HivModel.fromMap(maps[i]));
      }
    }
    return recordings;
  }

  /*Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$id = ?', whereArgs: [id]);
  }*/
  /*Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$id = ?', whereArgs: [id]);
  }*/

  Future<int> delete() async {
    var dbClient = await db;
    return await dbClient.delete(TABLE);
  }

  Future<int> update(HivModel messages) async {
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
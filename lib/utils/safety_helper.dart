import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:radauon/model/messages.dart';
import 'package:radauon/model/safetymodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class SafetyHelper {


  static final _dbName="rada.db";
  static final _dbVersion=2;
  static final _tableName="mentormessages";
  static final id="id";
  static final name="name";
  static final safedating="safedating";
  static final datingrules="datingrules";
  static final formen="formen";
  static final forladies="forladies";
  static final datingtips="datingtips";
  static final gbv="gbv";
  static final safetytips="safetytips";
  static final gbvintro="gbvintro";
  static final prominentplaces="prominentplaces";
  static final protectyourself="protectyourself";
  static final gbveffects="gbveffects";
  static final gettinghelp="gettinghelp";
  static final campussafety="campussafety";
  static final campussafetytips="campussafetytips";
  static final cybercrimesintro="cybercrimesintro";
  static final cybercrimestypes="cybercrimestypes";
  static final cybercrimestips="cybercrimestips";
  static final socialmediasafety="socialmediasafety";
  static final socialmediabenefits="socialmediabenefits";
  static final socialmediapitfalls="socialmediapitfalls";
  static final socialmediarules="socialmediarules";
  static final cyberlaws="cyberlaws";
  static final created_at="created_at";


  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'safety';
  static const String DB_NAME = 'safetydb.db';

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
        $safedating TEXT,
        $datingrules TEXT,
        $formen TEXT,
        $forladies TEXT,
        $cybercrimesintro TEXT,
        $cybercrimestips TEXT,
        $cybercrimestypes TEXT,
        $cyberlaws TEXT,
        $socialmediabenefits TEXT,
        $socialmediapitfalls TEXT,
        $socialmediarules TEXT,
        $socialmediasafety TEXT,
        $safetytips TEXT,
        $gbvintro TEXT,
        $prominentplaces TEXT,
        $protectyourself TEXT,
        $gbveffects TEXT,
        $gettinghelp TEXT,
        $campussafety TEXT,
        $campussafetytips TEXT,
        $created_at TEXT PRIMARY KEY
      )
      '''
    );
  }


  Future<int> save(Map<String,dynamic> data) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, data);
  }

  Future<List<SafetyModel>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE ORDER BY $id ASC");
    List<SafetyModel> recordings = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordings.add(SafetyModel.fromMap(maps[i]));
      }
    }
    return recordings;
  }

  /*Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$id = ?', whereArgs: [id]);
  }*/
  Future<int> delete() async {
    var dbClient = await db;
    return await dbClient.delete(TABLE);
  }

  Future<int> update(SafetyModel messages) async {
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
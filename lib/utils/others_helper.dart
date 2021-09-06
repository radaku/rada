import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:radauon/model/messages.dart';
import 'package:radauon/model/othersmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class OthersHelper {


  static final _dbName="rada.db";
  static final _dbVersion=2;
  static final _tableName="mentormessages";
  static final id="id";
  static final name="name";
  static final introduction="introduction";
  static final seventips="seventips";
  static final savingmoney="savingmoney";
  static final takeaction="takeaction";
  static final moneysavingtips="moneysavingtips";
  static final earnextracoin="earnextracoin";
  static final gratuationjob="gratuationjob";
  static final careerresourses="careerresourses";
  static final internships="internships";

  static final cvletter="cvletter";
  static final professionaljobs="professionaljobs";
  static final alumni="alumni";
  static final recentgratuates="recentgratuates";
  static final createopportunities="createopportunities";

  static final messagedate="created_at";


  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'radauonotherstable';
  static const String DB_NAME = 'radauonothersdb.db';

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
        $introduction TEXT,
        $seventips TEXT,
        $savingmoney TEXT,
        $takeaction TEXT,
        $moneysavingtips TEXT,
        $earnextracoin TEXT,
        $gratuationjob TEXT,
        $careerresourses TEXT,
        $internships TEXT,
        
        $cvletter TEXT,
        $professionaljobs TEXT,
        $alumni TEXT,
        $recentgratuates TEXT,
        $createopportunities TEXT,
        
        $messagedate TEXT PRIMARY KEY
      )
      '''
    );
  }


  Future<int> save(Map<String,dynamic> data) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, data);
  }

  Future<List<OthersModel>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE ORDER BY $id ASC");
    List<OthersModel> recordings = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordings.add(OthersModel.fromMap(maps[i]));
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

  Future<int> update(OthersModel messages) async {
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
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:radauon/model/drugsmodel.dart';
import 'package:radauon/model/messages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DrugsHelper {


  static final _dbName="rada.db";
  static final _dbVersion=2;
  static final _tableName="mentormessages";
  static final id="id";
  static final name="name";
  static final alcoholintroduction="alcoholintroduction";
  static final alcoholismsigns="alcoholismsigns";
  static final associatedhealthissues="associatedhealthissues";
  static final alcoholismtreatment="alcoholismtreatment";
  static final alcoholismhelp="alcoholismhelp";
  static final alcoholhelpcontacts="alcoholhelpcontacts";
  static final alcoholvideo="alcoholvideo";
  static final heroineintro="heroineintro";
  static final heroineeffects="heroineeffects";
  static final heroineinjection="heroineinjection";
  static final heroinerecovery="heroinerecovery";
  static final heroinefurtherhelp="heroinefurtherhelp";

  static final weedintro="weedintro";
  static final weedmyths="weedmyths";
  static final weedfacts="weedfacts";
  static final quitweed="quitweed";
  static final weednote="weednote";
  static final weedfaq="weedfaq";
  static final weeddyn="weeddyn";

  static final weedhelp="weedhelp";


  static final created_at="created_at";


  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'drugs';
  static const String DB_NAME = 'drugsdb.db';

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
        $alcoholintroduction TEXT,
        $alcoholismsigns TEXT,
        $associatedhealthissues TEXT,
        $alcoholismtreatment TEXT,
        $alcoholismhelp TEXT,
        $alcoholhelpcontacts TEXT,
        $alcoholvideo TEXT,
        $heroineintro TEXT,
        $heroineeffects TEXT,
        $heroineinjection TEXT,
        $heroinerecovery TEXT,
        $heroinefurtherhelp TEXT,
        $weedintro TEXT,
        $weedmyths TEXT,
        $weedfacts TEXT,
        $quitweed TEXT,
        $weednote TEXT,
        $weedfaq TEXT,
        $weedhelp TEXT,
        $weeddyn TEXT,
        $created_at TEXT PRIMARY KEY
      )
      '''
    );
  }


  Future<int> save(Map<String,dynamic> data) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, data);
  }

  Future<List<DrugsModel>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE ORDER BY $id ASC");
    List<DrugsModel> recordings = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordings.add(DrugsModel.fromMap(maps[i]));
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

  Future<int> update(DrugsModel messages) async {
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
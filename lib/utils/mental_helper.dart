import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:radauon/model/mentalmodel.dart';
import 'package:radauon/model/messages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MentalHelper {


  static final _dbName="rada.db";
  static final _dbVersion=2;
  static final _tableName="mentormessages";
  static final id="id";
  static final name="name";
  static final mentaldef="mentaldef";
  static final mentalilldef="mentalilldef";
  static final riskfactors="riskfactors";
  static final disorders="disorders";
  static final suicideprevention="suicideprevention";
  static final suicidehelp="suicidehelp";
  static final suicidevideo="suicidevideo";
  static final eatingdisordersinto="eatingdisordersinto";
  static final anorexia="anorexia";

  static final bulimia="bulimia";
  static final biengeeating="biengeeating";
  static final eatinghelp="eatinghelp";
  static final mentalhelpintro="mentalhelpintro";

  static final psychotherapy="psychotherapy";
  static final medication="medication";
  static final selfhelp="selfhelp";

  static final created_at="created_at";


  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'mental';
  static const String DB_NAME = 'mentalhltdb.db';

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
        $mentaldef TEXT,
        $mentalilldef TEXT,
        $riskfactors TEXT,
        $disorders TEXT,
        $suicideprevention TEXT,
        $suicidehelp TEXT,
        $suicidevideo TEXT,
        $eatingdisordersinto TEXT,
        $anorexia TEXT,
        
        $bulimia TEXT,
        $biengeeating TEXT,
        $eatinghelp TEXT,
        $mentalhelpintro TEXT,
        $psychotherapy TEXT,
        
        $medication TEXT,
        $selfhelp TEXT,
        
        $created_at TEXT PRIMARY KEY
      )
      '''
    );
  }


  Future<int> save(Map<String,dynamic> data) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, data);
  }

  Future<List<MentalModel>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE ORDER BY $id ASC");
    List<MentalModel> recordings = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordings.add(MentalModel.fromMap(maps[i]));
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

  Future<int> update(MentalModel messages) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, messages.toMap(),
        where: '$id = ?', whereArgs: [messages.id]);
  }

 /* Future<int> update(Map reproductive) async {
    var dbClient = await db;

    return await dbClient.update(TABLE, reproductive,);
  }*/

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}
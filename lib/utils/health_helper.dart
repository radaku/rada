import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:radauon/model/healthmodel.dart';
import 'package:radauon/model/messages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class HealthHelper {


  static final _dbName="rada.db";
  static final _dbVersion=2;
  static final _tableName="mentormessages";
  static final id="id";
  static final name="name";
  static final noncommunicableintro="noncommunicableintro";
  static final keyriskfactors="keyriskfactors";
  static final poorlifestyles="poorlifestyles";
  static final healthylifestyles="healthylifestyles";
  static final weightobesity="weightobesity";
  static final weightmanagement="weightmanagement";
  static final weightmanagementrecons="weightmanagementrecons";
  static final weightmanagementhelp="weightmanagementhelp";

  static final nutritionintro="nutritionintro";
  static final foodproduction="foodproduction";
  static final foodconsumption="foodconsumption";
  static final nutrientutilization="nutrientutilization";
  static final posthavest="posthavest";
  static final physicalinactivity="physicalinactivity";
  static final nutrientsources="nutrientsources";
  static final nutritionandpregnancy="nutritionandpregnancy";
  static final nutritionandhiv="nutritionandhiv";

  static final hygieneintro="hygieneintro";
  static final hygieneimportance="hygieneimportance";
  static final goodhabits="goodhabits";
  static final emergencyplanning="emergencyplanning";
  static final selfmaintainace="selfmaintainace";
  static final offensivehabits="offensivehabits";
  static final support="support";
  static final remember="remember";

  static final physicalintro="physicalintro";
  static final benefits="benefits";

  static final messagedate="created_at";


  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'healthtable';
  static const String DB_NAME = 'radauonhealthdb.db';

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
        $noncommunicableintro TEXT,
        $keyriskfactors TEXT,
        $poorlifestyles TEXT,
        $healthylifestyles TEXT,
        $weightobesity TEXT,
        $weightmanagement TEXT,
        $weightmanagementrecons TEXT,
        $weightmanagementhelp TEXT,
        $nutritionintro TEXT,
        $foodproduction TEXT,
        
        $foodconsumption TEXT,
        $nutrientutilization TEXT,
        $posthavest TEXT,
        $physicalinactivity TEXT,
        $nutrientsources TEXT,
        $nutritionandpregnancy TEXT,
        $nutritionandhiv TEXT,
        $hygieneintro TEXT,
        $hygieneimportance TEXT,
        
        $goodhabits TEXT,
        $emergencyplanning TEXT,
        $selfmaintainace TEXT,
        $offensivehabits TEXT,
        $support TEXT,
        $remember TEXT,
        $physicalintro TEXT,
        $benefits TEXT,
       
        
        
        $messagedate TEXT PRIMARY KEY
      )
      '''
    );
  }


  Future<int> save(Map<String,dynamic> data) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, data);
  }

  Future<List<HealthModel>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE ORDER BY $id ASC");
    List<HealthModel> recordings = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordings.add(HealthModel.fromMap(maps[i]));
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

  Future<int> update(HealthModel messages) async {
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
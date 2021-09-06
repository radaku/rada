import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:radauon/model/messages.dart';
import 'package:radauon/model/reproductive.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ReproHelper {


  static final _dbName="rada.db";
  static final _dbVersion=2;
  static final _tableName="mentormessages";
  static final id="id";
  static final name="name";
  static final contraceptionintroduction="contraceptionintroduction";
  static final methods="methods";
  static final condomswork="condomswork";
  static final injectable ="injectable";
  static final oralpill="oralpill";
  static final iucds="iucds";
  static final implants="implants";
  static final emergency ="emergency ";
  static final contraceptionvideo="contraceptionvideo";
  static final know="know";
  static final boyfriend="boyfriend";
  static final night="night";
  static final casual="casual";
  static final sponsor="sponsor";
  static final dyn1="dyn1";
  static final sponsorvideo="sponsorvideo";
  static final pregnancydyn="pregnancydyn";
  static final pregnancycauses="pregnancycauses";
  static final pregnancysigns="pregnancysigns";
  static final pregnancytest="pregnancytest";
  static final prenatalcare="prenatalcare";
  static final antinetalcare="antinetalcare";
  static final postnatal="postnatal";
  static final pregnancynutrition="pregnancynutrition";
  static final pregnancydanger="pregnancydanger";
  static final stiintroduction="stiintroduction";
  static final riskfactors="riskfactors";
  static final stitypes="stitypes";
  static final stisigns="stisigns";
  static final commonstisigns="commonstisigns";
  static final treatment="treatment";
  static final protectiontips="protectiontips";
  static final facts="facts";
  static final myths="myths";
  static final stisharm="stisharm";
  static final hivsti="hivsti";
  static final created_at="created_at";


  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'reproductivetable';
  static const String DB_NAME = 'reproductiondb.db';

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
        $contraceptionintroduction TEXT,
        $methods TEXT,
        $condomswork TEXT,
        $injectable TEXT,
        $oralpill TEXT,
        $iucds TEXT,
        $implants TEXT,
        $emergency TEXT,
        $contraceptionvideo TEXT,
        $know TEXT,
        $boyfriend TEXT,
        $night TEXT,
        $casual TEXT,
        $sponsor TEXT,
        $sponsorvideo TEXT,
        $dyn1 TEXT,
        $pregnancydyn TEXT,
        $pregnancycauses TEXT,
        $pregnancysigns TEXT,
        $pregnancytest TEXT,
        $prenatalcare TEXT,
        $antinetalcare TEXT,
        $postnatal TEXT,
        $pregnancynutrition TEXT,
        $pregnancydanger TEXT,
        
        $stiintroduction TEXT,
        $riskfactors TEXT,
        $stitypes TEXT,
        $stisigns TEXT,
        $commonstisigns TEXT,
        $treatment TEXT,
        $protectiontips TEXT,
        $facts TEXT,
        $myths TEXT,
        $stisharm TEXT,
        $hivsti TEXT,
        $created_at TEXT PRIMARY KEY
      )
      '''
    );
  }


  Future<int> save(Map<String,dynamic> data) async {
    var dbClient = await db;
    return await dbClient.insert(TABLE, data);
  }

  Future<List<Reproductive>> getMessages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE ORDER BY $id ASC");
    List<Reproductive> recordings = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        recordings.add(Reproductive.fromMap(maps[i]));
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

  /*Future<int> update(Reproductive reproductive) async {
    var dbClient = await db;

    return await dbClient.update(TABLE, reproductive.toMap(),
        where: '$id = ?', whereArgs: [reproductive.id]);
  }*/

  Future<int> update(Reproductive reproductive) async {
    var dbClient = await db;

    return await dbClient.update(TABLE, reproductive.toMap(),
        where: '$created_at = ?', whereArgs: [reproductive.created_at]);
  }


  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}
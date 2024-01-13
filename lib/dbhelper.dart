import 'dart:async';
import 'dart:io' as io;
import 'package:garb/photo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _database;
  static const String? ID = 'id';
  static const String? NAME = 'photo_name';
  static const String? TABLE = 'PhotosTable';
  static const String? DB_NAME = 'photos.db';
  static final DBHelper db = DBHelper._();
  DBHelper._();
  Future<Database> get database async {
    if (null != _database) {
      return _database!;
    }
    _database = await initDb();
    return _database!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER, $NAME TEXT)");
  }

  save(Photo employee) async {
    var dbClient = await database;
    await dbClient.insert(TABLE!, employee.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Photo>> getAllPhotos() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(TABLE!);
    List<Photo> list = maps.isNotEmpty
        ? maps.map((product) => Photo.fromMap(product)).toList()
        : [];
    return list;
  }
}

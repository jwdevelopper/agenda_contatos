import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContatoHelper {
  static final ContatoHelper _instance = ContatoHelper.internal();

  factory ContatoHelper() => _instance;

  ContatoHelper.internal();

  Database _db;

  get db {
    if(_db != null) {
      return _db; 
    } else {
      _db = initDb();
    }
  }

  initDb() async{
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contatos.db");
    openDatabase(path, version: 1, onCreate: (Database db, int novaVersao) async {
      await db.execute();
    });
  }
}
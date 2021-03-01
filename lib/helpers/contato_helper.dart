

import 'dart:async';

import 'package:agenda_contatos/model/contato.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String telefoneColumn = "telefoneColumn";
final String imgColumn = "imgColumn";

class ContatoHelper {
  static final ContatoHelper _instance = ContatoHelper.internal();

  factory ContatoHelper() => _instance;

  ContatoHelper.internal();

  Database _db;

  Future<Database> get db async{
    if(_db != null) {
      return _db; 
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async{
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contatos.db");
    return await openDatabase(path, version: 1, onCreate: (Database db, int novaVersao) async {
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $emailColumn TEXT,"
        "$telefoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  Future<Contato> salvarContato(Contato contato) async {
    Database dbContato = await db;
    contato.id = await dbContato.insert(contactTable, contato.toMap());
    return contato;
  }

  Future<Contato> getContato(int id) async {
    Database dbContato = await db;
    List<Map> maps = await dbContato.query(contactTable, 
    columns: [idColumn,nomeColumn,emailColumn,telefoneColumn,imgColumn],
    where: "$idColumn = ?",
    whereArgs: [id]);
    if(maps.length > 0){
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletarContato(int id) async {
    Database dbContato = await db;
    return await dbContato.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContato(Contato contato) async {
    Database dbContato = await db;
    return await dbContato.update(contactTable, contato.toMap(), where: "$idColumn = ?", whereArgs: [contato.id]);
  }

  Future<List> getContatos() async {
    Database dbContato = await db;
    List listMap = await dbContato.rawQuery("SELECT * FROM $contactTable");
    List<Contato> listaContatos = List();
    for(Map m in listMap){
      listaContatos.add(Contato.fromMap(m));
    }
    return listaContatos;
  }

  Future<int> getNumber() async {
    Database dbContato = await db;
    return Sqflite.firstIntValue(await dbContato.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database dbContato = await db;
    dbContato.close();
  }
}
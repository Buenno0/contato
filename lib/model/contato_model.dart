import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

const String contatoTable = "contato";
const String idColumn = "idcontato";
const String nomeColumn = "nome";
const String emailColumn = "email";
const String foneColumn = "fone";
const String imgColumn = "img";

class ContatoModel{
  static final ContatoModel _instance = ContatoModel.internal();
  factory ContatoModel() => _instance;
  ContatoModel.internal();
  Database? _db;

  Future<Database?> get db async {
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database?> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contato.db");

    return await openDatabase(path, version: 1,
     onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $contatoTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $emailColumn TEXT, $foneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }

  Future<Contato> saveContato(Contato contato) async {
    Database? dbContato = await db;
    contato.id = await dbContato!.insert(contatoTable, contato.toMap());
    return contato;
  }

  Future<Contato?> getContato(int id) async {
    Database? dbContato = await db;
    List<Map> maps = await dbContato!.query(contatoTable,
      columns: [idColumn, nomeColumn, emailColumn, foneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id]);
    if(maps.isNotEmpty){
      return Contato.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<int> deleteContato(int id) async {
    Database? dbContato = await db;
    return await dbContato!.delete(contatoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContato(Contato contato) async {
    Database? dbContato = await db;
    return await dbContato!.update(contatoTable, contato.toMap(), where: "$idColumn = ?", whereArgs: [contato.id]);
  }

  Future<List<Contato>> getAllContatos() async {
    Database? dbContato = await db;
    List listMap = await dbContato!.rawQuery("SELECT * FROM $contatoTable");
    List<Contato> listContato = [];
    for(Map m in listMap){
      listContato.add(Contato.fromMap(m));
    }
    return listContato;
  }

  Future<int?> getNumber() async {
    Database? dbContato = await db;
    return Sqflite.firstIntValue(await dbContato!.rawQuery("SELECT COUNT(*) FROM $contatoTable"));
  }

  Future close() async {
    Database? dbContato = await db;
    dbContato!.close();
  }

}

class Contato{
 late int id;
 late String nome;
 late String email;
 late String fone;
 late String img;

  Contato(){}
 
 Contato.fromMap(Map map){
  id = map[idColumn];
  nome = map [nomeColumn];
  email = map [emailColumn];
  fone = map [foneColumn];
  img = map [imgColumn];
 }

 Map<String, dynamic> toMap(){
  Map<String, dynamic> map = {
    nomeColumn: nome,
    emailColumn: email,
    foneColumn: fone,
    imgColumn: img,
  };
  if(id != 0){
    map[idColumn] = id;
  }
  return map;
 }

 @override
  String toString() {
    return "\n Contato: \n id: $id, \n nome: $nome, \n email: \n $email, \n fone: \n $fone, \n img: \n $fone";
  }
}
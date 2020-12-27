import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/src/models/scan_models.dart';
export 'package:qr_reader/src/models/scan_models.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";


class DBProvider {

  static Database _database;

  //_() es un constructor privado
  static final DBProvider db = DBProvider._();

  DBProvider._();

  // Patrón SINGLETON
  Future<Database> get database async {
    if(_database != null){
      return _database;
    } else {
      _database = await initDB();

      return _database;
    }
  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "ScansDB.db");

    //Creando la DB
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE Scans ("
          " id INTEGER PRIMARY KEY,"
          " tipo TEXT,"
          " valor TEXT"
          ")"
        );
      },
    );
    
  }

  // CREAR REGISTROS | nuevoScanRaw y nuevoScan HACEN LO MISMO, pero nuevoScan es más fácil
  nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await database;

    final resultado = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valor) "
      "VALUES (${nuevoScan.id}, ${nuevoScan.tipo}, ${nuevoScan.valor})"
    );

    return resultado;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final resultado = await db.insert("Scans", nuevoScan.toJson());
    return resultado;
  }

  //SELECT - Obtener información
  getScanId(int id) async {
    final db = await database;
    // ? es que tiene 1 argumento, ?? pues 2, etc...
    // Retorna 1 scan por ID
    final resultado = await db.query("Scans", where: "id = ?", whereArgs: [id]);

    return resultado.isNotEmpty ? ScanModel.fromJson(resultado.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final resultado = await db.query("Scans");

    List<ScanModel> list = resultado.isNotEmpty 
                            ? resultado.map((i) => ScanModel.fromJson(i)).toList()
                            : [];
    return list;             
  }

   Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final resultado = await db.rawQuery("SELECT * FROM Scans WHERE tipo = $tipo");

    List<ScanModel> list = resultado.isNotEmpty 
                            ? resultado.map((i) => ScanModel.fromJson(i)).toList()
                            : [];
    return list;             
  }

  // ACTUALIZAR REGISTROS
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final resultado = await db.update("Scans", nuevoScan.toJson(), 
      where: "id = ?", 
      whereArgs: [nuevoScan.id]
    );

    return resultado;
  }

  // ELIMINAR REGISTROS

  Future<int> deleteScan(int id) async {
    final db = await database;
    final resultado = await db.delete("Scans", where: "id = ?", whereArgs: [id]);
    // final resultado = await db.delete("Scans"); BORRA TODOSCANS
    return resultado;
  }

  // ELIMINAR TODOS LOS REGISTROS
  Future<int> deleteAll() async {
    final db = await database;
    final resultado = await db.rawDelete("DELETE FROM Scans");
     return resultado;
  }

}
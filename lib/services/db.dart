import 'dart:async';
import 'package:ekf/model/todo_item.dart';
import 'package:sqflite/sqflite.dart';

mixin DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      var _path = '${getDatabasesPath()}expample';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future onCreate(Database db, int version) async => db.execute(
      'CREATE TABLE table_EKF (id INTEGER PRIMARY KEY NOT NULL, firstName STRING, lastName STRING, secondName STRING, dateBirth STRING, position STRING, complete BOOLEAN)');

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, TodoItem model) async =>
      _db.insert(table, model.toMap());

  static Future<int> update(String table, TodoItem model) async =>
      _db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, TodoItem model) async =>
      _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
}

import 'dart:io';

import 'package:ekf/model/children.dart';
import 'package:ekf/model/parent.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseClient {
  Database _db;

  Future create() async {
    var path = await getApplicationDocumentsDirectory();
    var dbPath = join(path.path, 'database.db');

    _db = await openDatabase(dbPath, version: 1, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE parent (id INTEGER PRIMARY KEY,firstName TEXT,lastName TEXT, secondName TEXT,dateBirth TEXT, position TEXT, complete BOOLEAN');
    await db.execute(
        'CREATE TABLE children (id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT, secondName TEXT, dateBirth TEXT, complete BOOLEAN,parent_id INTEGER NOT NULL, FOREIGN KEY (parent_id) REFERENCES parent (id)  ON DELETE NO ACTION ON UPDATE NO ACTION))');
  }

  Future<Parent> upsertUser(Parent parent) async {
    var count = Sqflite.firstIntValue(await _db.rawQuery(
        'SELECT COUNT(*) FROM user WHERE username = ?', [parent.firstName]));
    if (count == 0) {
      parent.id = await _db.insert('user', parent.toMap());
    } else {
      await _db.update('user', parent.toMap(),
          where: 'id = ?', whereArgs: [parent.id]);
    }

    return parent;
  }

  Future<Children> upsertStory(Children children) async {
    if (children.id == null) {
      children.id = await _db.insert('children', children.toMap());
    } else {
      await _db.update('children', children.toMap(),
          where: 'id = ?', whereArgs: [children.id]);
    }

    return children;
  }

  Future<Parent> fetchUser(int id) async {
    List<Map> results = await _db.query('parent',
        columns: Parent.columns, where: 'id = ?', whereArgs: [id]);

    var parent = Parent.fromMap(results[0] as Map<String, dynamic>);

    return parent;
  }

  Future<Children> fetchStory(int id) async {
    List<Map> results = await _db.query('children',
        columns: Children.columns, where: 'id = ?', whereArgs: [id]);

    var children = Children.fromMap(results[0] as Map<String, dynamic>);

    return children;
  }

  Future<List<Children>> fetchLatestStories(int limit) async {
    List<Map> results = await _db.query('children',
        columns: Children.columns, limit: limit, orderBy: 'id DESC');

    var childrens = <Children>[];
    results.forEach((result) {
      var childr = Children.fromMap(result as Map<String, dynamic>);
      childrens.add(childr);
    });

    return childrens;
  }
}

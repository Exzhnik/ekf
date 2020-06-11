// import 'dart:async';
// import 'package:ekf/model/parent.dart';
// import 'package:sqflite/sqflite.dart';

// class DB {
//   static Database _db;

//   static int get _version => 1;

//   static Future<void> init() async {
//     if (_db != null) {
//       return;
//     }

//     try {
//       var _path = '${getDatabasesPath()}expample';
//       _db = await openDatabase(_path, version: _version, onCreate: onCreate);
//     } on Exception catch (e) {
//       print(e);
//     }
//   }

// }

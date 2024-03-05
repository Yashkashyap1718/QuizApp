import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_quiz/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();

    return await openDatabase(
      join(path, 'flutterQuiz.db'),
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uid TEXT,
            name TEXT,
            phoneNumber TEXT,
            email TEXT
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 3) {
          // Check if the quizTime column does not exist before attempting to add it

          List<Map<String, dynamic>> columns =
              await db.rawQuery("PRAGMA table_info(users)");

          bool quizTimeColumnExists = columns.any((column) =>
              column['name'].toString().toLowerCase() == 'quizTime');

          if (!quizTimeColumnExists) {
            await db.execute('ALTER TABLE users ADD COLUMN quizTime TEXT');
          }
        }
      },
    );
  }

  Future<bool> insertUser(UserModel user) async {
    try {
      final db = await initDatabase();
      await db.insert('users', user.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("-------------------- error ------------ $e");
      }
      return false;
    }
  }

  Future<UserModel> getUsers() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('users');

    if (maps.isNotEmpty) {
      return maps.map((e) => UserModel.fromJson(e)).first;
    } else {
      return UserModel();
    }
  }

  Future<void> deleteUser(int id) async {
    final db = await initDatabase();
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> cleanUserTable() async {
    final db = await initDatabase();

    await db.delete("users");
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:team_19/models/connections_model.dart';
import 'package:team_19/models/letterquest_model.dart';
import 'package:team_19/models/wordladder_model.dart';
import 'package:team_19/models/user_model.dart';
import 'package:team_19/data/seed_connections.dart';
import 'package:team_19/data/seed_letterquest.dart';
import 'package:team_19/data/seed_wordladder.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Data.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE Connections(
            id INTEGER PRIMARY KEY NOT NULL, 
            categories TEXT NOT NULL
          );
        """);

        await DatabaseHelper.addConnection(connection1);
        await DatabaseHelper.addConnection(connection2);
        await DatabaseHelper.addConnection(connection3);
        await DatabaseHelper.addConnection(connection4);
        await DatabaseHelper.addConnection(connection5);


        await db.execute("""
          CREATE TABLE Letterquest(
            id INTEGER PRIMARY KEY NOT NULL, 
            phrase TEXT NOT NULL, 
            hint TEXT NOT NULL
          );
        """);
        
        await DatabaseHelper.addLetterquest(letterquest1);
        await DatabaseHelper.addLetterquest(letterquest2);
        await DatabaseHelper.addLetterquest(letterquest3);
        await DatabaseHelper.addLetterquest(letterquest4);
        await DatabaseHelper.addLetterquest(letterquest5);

        await db.execute("""
          CREATE TABLE Wordladder(
            id INTEGER PRIMARY KEY NOT NULL, 
            wordList TEXT NOT NULL
          );
        """);

        await DatabaseHelper.addWordladder(wordLadder1);
        await DatabaseHelper.addWordladder(wordLadder2);
        await DatabaseHelper.addWordladder(wordLadder3);
        await DatabaseHelper.addWordladder(wordLadder4);
        await DatabaseHelper.addWordladder(wordLadder5);

        await db.execute("""
          CREATE TABLE Users(
            name TEXT PRIMARY KEY NOT NULL, 
            connectionsScores TEXT NOT NULL, 
            connectionsTimes TEXT NOT NULL, 
            letterquestScores TEXT NOT NULL, 
            letterquestTimes TEXT NOT NULL, 
            wordladderScores TEXT NOT NULL, 
            wordladderTimes TEXT NOT NULL
          );
        """);
      },
      version: _version,
    );
  }

  // CRUD for Connnection
  static Future<int> addConnection(Connnection conn) async {
    final db = await _getDB();
    return await db.insert("Connections", conn.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateConnection(Connnection conn) async {
    final db = await _getDB();
    return await db.update("Connections", conn.toJson(), where: 'id = ?', whereArgs: [conn.id]);
  }

  static Future<int> deleteConnection(int id) async {
    final db = await _getDB();
    return await db.delete("Connections", where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Connnection>> fetchAllConnections() async {
    final db = await _getDB();
    final data = await db.query("Connections");
    return data.map((e) => Connnection.fromJson(e)).toList();
  }

  static Future<Connnection?> fetchConnectionById(int id) async {
    final db = await _getDB();
    final data = await db.query("Connections", where: 'id = ?', whereArgs: [id]);
    return data.isNotEmpty ? Connnection.fromJson(data.first) : null;
  }

  // CRUD for Letterquest
  static Future<int> addLetterquest(Letterquest lq) async {
    final db = await _getDB();
    return await db.insert("Letterquest", lq.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateLetterquest(Letterquest lq) async {
    final db = await _getDB();
    return await db.update("Letterquest", lq.toJson(), where: 'id = ?', whereArgs: [lq.id]);
  }

  static Future<int> deleteLetterquest(int id) async {
    final db = await _getDB();
    return await db.delete("Letterquest", where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Letterquest>> fetchAllLetterquests() async {
    final db = await _getDB();
    final data = await db.query("Letterquest");
    return data.map((e) => Letterquest.fromJson(e)).toList();
  }

  static Future<Letterquest?> fetchLetterquestById(int id) async {
    final db = await _getDB();
    final data = await db.query("Letterquest", where: 'id = ?', whereArgs: [id]);
    return data.isNotEmpty ? Letterquest.fromJson(data.first) : null;
  }

  // CRUD for Wordladder
  static Future<int> addWordladder(Wordladder wl) async {
    final db = await _getDB();
    return await db.insert("Wordladder", wl.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateWordladder(Wordladder wl) async {
    final db = await _getDB();
    return await db.update("Wordladder", wl.toJson(), where: 'id = ?', whereArgs: [wl.id]);
  }

  static Future<int> deleteWordladder(int id) async {
    final db = await _getDB();
    return await db.delete("Wordladder", where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Wordladder>> fetchAllWordladders() async {
    final db = await _getDB();
    final data = await db.query("Wordladder");
    return data.map((e) => Wordladder.fromJson(e)).toList();
  }

  static Future<Wordladder?> fetchWordladderById(int id) async {
    final db = await _getDB();
    final data = await db.query("Wordladder", where: 'id = ?', whereArgs: [id]);
    return data.isNotEmpty ? Wordladder.fromJson(data.first) : null;
  }

  // CRUD for User
  static Future<int> addUser(User user) async {
    final db = await _getDB();
    return await db.insert("Users", user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateUser(User user) async {
    final db = await _getDB();
    return await db.update("Users", user.toJson(), where: 'name = ?', whereArgs: [user.name]);
  }

  static Future<int> deleteUser(String name) async {
    final db = await _getDB();
    return await db.delete("Users", where: 'name = ?', whereArgs: [name]);
  }

  static Future<List<User>> fetchAllUsers() async {
    final db = await _getDB();
    final data = await db.query("Users");
    return data.map((e) => User.fromJson(e)).toList();
  }

  static Future<User?> fetchUserByName(String name) async {
    final db = await _getDB();
    final data = await db.query("Users", where: 'name = ?', whereArgs: [name]);
    return data.isNotEmpty ? User.fromJson(data.first) : null;
  }
}

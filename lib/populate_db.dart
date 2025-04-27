import 'package:Team-19/populate_db.dart' as populate_db;
import 'package:sqflite/sqflite.dart';// need to make these local
import 'package:path/path.dart'; //need to make these local 

Future<void> initializeDatabase() async {
  //Open sq database(db)
  final db = await openDatabase(
    join(await getDatabasesPath(), 'Data.db'), 
    version: 1, 
    onCreate: (db,version) {
      return db.execute(
        'CREATE TABLE users (id INTEGER PRIMARY KEY, categories TEXT NOT NULL)'
      );
    },
  );

//Checks if table is empty
final List<Map<String, dynamic>> userList = await db.query('users');

if (userList.isEmpty) {
  print ("Database is empty.");

  //Dummy data
  final users = [
    {'name': 'Eve'}, //category here too?
    {'name': 'Mark'},
    {'name': 'Rex'},
  ];

  for (var user in users) {
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  print ('Database has been populated.');
} else {
  print ('Database already contains data. No action taken.');
  }
}

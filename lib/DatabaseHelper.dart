// ignore_for_file: file_names, depend_on_referenced_packages
/*
Nombre: Jose Andres Trinidad Almeyda
Matricula: 2022-0575
Materia: Introduccion del desarrollo de aplicaciones moviles
Facilitador Amadiz Suarez Genao
*/

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'event.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  late Database _db;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<void> initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'events.db');
    _db = await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date TEXT,
        audioPath TEXT, 
        photoPath TEXT
      )
    ''');
  }

  Future<int> insertEvent(Event event) async {
    return await _db.insert('events', event.toMapExceptId());
  }

  Future<List<Event>> retrieveEvents() async {
    final List<Map<String, dynamic>> eventMaps =
        await _db.query('events', orderBy: 'date');
    return eventMaps.map((eventMap) => Event.fromMap(eventMap)).toList();
  }

  Future<void> updateEvent(Event event) async {
    await _db.update(
      'events',
      event.toMapExceptId(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(int id) async {
    await _db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllEvents() async {
    await _db.delete('events');
  }
}

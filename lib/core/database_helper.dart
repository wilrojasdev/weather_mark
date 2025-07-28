// lib/core/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'weather_app.db';
  static const int _databaseVersion = 2;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    return _database!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Crear tabla de usuarios
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT NOT NULL,
        picture TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Crear tabla de historial del clima
    await db.execute('''
      CREATE TABLE weather_history (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        name TEXT NOT NULL,
        temperature REAL NOT NULL,
        feelsLike REAL NOT NULL,
        humidity INTEGER NOT NULL,
        windSpeed REAL NOT NULL,
        pressure INTEGER NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        visibility INTEGER NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        savedAt INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_weather_userId ON weather_history(userId)
    ''');

    await db.execute('''
      CREATE INDEX idx_weather_savedAt ON weather_history(savedAt)
    ''');
  }
}

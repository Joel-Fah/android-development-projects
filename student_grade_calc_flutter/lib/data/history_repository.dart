import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/grade_session.dart';

/// Manages persistent storage of [GradeSession] records using SQLite.
///
/// Call [init] once at app startup (in main.dart) before using any other method.
/// All methods are async because database operations can take time.
class HistoryRepository {
  static const String _dbName = 'grade_history.db';
  static const String _table = 'sessions';

  Database? _db;

  /// Opens (or creates) the SQLite database.
  ///
  /// On desktop platforms (Windows, macOS, Linux), sqflite needs an FFI
  /// (Foreign Function Interface) initializer because there is no native
  /// SQLite plugin bridge like on Android/iOS.
  Future<void> init() async {
    // sqflite_common_ffi must be initialized for desktop platforms
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      // Override the default databaseFactory with the FFI one
      databaseFactory = databaseFactoryFfi;
    }

    // Get the app's documents directory — a safe place to store databases
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(docsDir.path, _dbName);

    _db = await openDatabase(
      dbPath,
      version: 1,
      // onCreate is called only the very first time the app opens this database
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id              INTEGER PRIMARY KEY AUTOINCREMENT,
            fileName        TEXT    NOT NULL,
            processedAt     TEXT    NOT NULL,
            totalStudents   INTEGER NOT NULL,
            passCount       INTEGER NOT NULL,
            failCount       INTEGER NOT NULL,
            classAverage    REAL    NOT NULL,
            studentsJson    TEXT    NOT NULL,
            headersJson     TEXT    NOT NULL
          )
        ''');
      },
    );
  }

  Database get _database {
    if (_db == null) {
      throw StateError('HistoryRepository not initialised. Call init() first.');
    }
    return _db!;
  }

  /// Saves a completed [session] to the database.
  Future<void> saveSession(GradeSession session) async {
    await _database.insert(_table, session.toMap());
  }

  /// Returns all sessions ordered by most recent first.
  Future<List<GradeSession>> getAllSessions() async {
    final rows = await _database.query(
      _table,
      orderBy: 'processedAt DESC',
    );
    return rows.map(GradeSession.fromMap).toList();
  }

  /// Deletes the session with the given [id].
  Future<void> deleteSession(int id) async {
    await _database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  /// Removes every session from the database.
  Future<void> clearAll() async {
    await _database.delete(_table);
  }
}

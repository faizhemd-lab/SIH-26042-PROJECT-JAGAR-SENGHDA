import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class DatabaseService {
  static DatabaseService? _instance;
  late final Database _db;

  DatabaseService._(this._db);

  static DatabaseService get instance {
    if (_instance == null) {
      throw StateError('DatabaseService must be initialized before use.');
    }
    return _instance!;
  }

  static Future<DatabaseService> initialize() async {
    if (_instance != null) return _instance!;

    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, 'jagar_senghda.db');

    final db = sqlite3.open(dbPath);

    // Enable WAL mode and performance pragmas for multi-isolate safety
    db.execute('PRAGMA journal_mode = WAL;');
    db.execute('PRAGMA synchronous = NORMAL;');
    db.execute('PRAGMA busy_timeout = 5000;');
    db.execute('PRAGMA foreign_keys = ON;');

    _createTables(db);

    _instance = DatabaseService._(db);
    return _instance!;
  }

  static void _createTables(Database db) {
    db.execute('''
      CREATE TABLE IF NOT EXISTS audio_sessions (
        id TEXT PRIMARY KEY,
        file_path TEXT NOT NULL,
        duration_ms INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        status TEXT NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS transcriptions (
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        text TEXT NOT NULL,
        confidence REAL NOT NULL,
        start_time_ms INTEGER NOT NULL,
        end_time_ms INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (session_id) REFERENCES audio_sessions (id) ON DELETE CASCADE
      );
    ''');

    db.execute('''
      CREATE INDEX IF NOT EXISTS idx_transcriptions_session 
      ON transcriptions(session_id);
    ''');
  }

  // --- CRUD Operations ---

  void insertSession({
    required String id,
    required String filePath,
    required int durationMs,
    required String status,
  }) {
    final stmt = _db.prepare('''
      INSERT INTO audio_sessions (id, file_path, duration_ms, created_at, status)
      VALUES (?, ?, ?, ?, ?);
    ''');
    stmt.execute([id, filePath, durationMs, DateTime.now().millisecondsSinceEpoch, status]);
    stmt.dispose();
  }

  void insertTranscription({
    required String id,
    required String sessionId,
    required String text,
    required double confidence,
    required int startTimeMs,
    required int endTimeMs,
  }) {
    final stmt = _db.prepare('''
      INSERT INTO transcriptions (id, session_id, text, confidence, start_time_ms, end_time_ms, created_at)
      VALUES (?, ?, ?, ?, ?, ?, ?);
    ''');
    stmt.execute([
      id,
      sessionId,
      text,
      confidence,
      startTimeMs,
      endTimeMs,
      DateTime.now().millisecondsSinceEpoch,
    ]);
    stmt.dispose();
  }

  List<Map<String, dynamic>> getTranscriptionsForSession(String sessionId) {
    final ResultSet results = _db.select('''
      SELECT * FROM transcriptions 
      WHERE session_id = ? 
      ORDER BY start_time_ms ASC;
    ''', [sessionId]);

    return results.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  void close() {
    _db.dispose();
    _instance = null;
  }
}

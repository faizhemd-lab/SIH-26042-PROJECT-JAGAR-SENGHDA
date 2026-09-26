import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Offline SQLite Database Service running in Write-Ahead Logging (WAL) Mode.
/// Target performance: <10ms query overhead on ≤2GB RAM Android hardware.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('jagar_senghda.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        // Enable WAL mode for high-concurrency offline access
        await db.execute('PRAGMA journal_mode = WAL;');
        await db.execute('PRAGMA synchronous = NORMAL;');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. NIPUN Bharat Foundational Literacy & Numeracy Lakshyas
    await db.execute('''
      CREATE TABLE fln_targets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        grade_level TEXT NOT NULL,
        subject TEXT NOT NULL,
        target_code TEXT UNIQUE NOT NULL,
        description_hindi TEXT NOT NULL,
        difficulty_rank INTEGER DEFAULT 1
      );
    ''');

    // 2. Localized Vernacular Dictionary
    await db.execute('''
      CREATE TABLE dictionary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hindi_term TEXT NOT NULL,
        santhali_term TEXT,
        santhali_script_ol_chiki TEXT,
        mundari_term TEXT,
        ho_term TEXT,
        ho_script_warang_chiti TEXT,
        phonetic_ipa TEXT,
        category TEXT
      );
    ''');

    // 3. Cultural Metaphor Swaps
    await db.execute('''
      CREATE TABLE metaphor_swaps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        standard_textbook_metaphor TEXT NOT NULL,
        tribal_cultural_metaphor TEXT NOT NULL,
        region_belt TEXT DEFAULT 'Jharkhand_Tribal_Belt'
      );
    ''');

    // Seed offline lookup data for immediate UI demo testing
    await db.rawInsert('''
      INSERT INTO dictionary (hindi_term, santhali_term, santhali_script_ol_chiki, mundari_term, ho_term, category) 
      VALUES ('पानी', 'दाः', 'ᱫᱟᱜ', 'दाअ', 'दाः', 'basics');
    ''');

    await db.rawInsert('''
      INSERT INTO metaphor_swaps (standard_textbook_metaphor, tribal_cultural_metaphor, region_belt) 
      VALUES ('ट्रैफिक लाइट', 'महुआ के फूल', 'Santhal Pargana');
    ''');
  }

  /// Low-latency query for Hindi to Native Dialect mappings
  Future<List<Map<String, dynamic>>> searchDictionary(String term) async {
    final db = await instance.database;
    return await db.query(
      'dictionary',
      where: 'hindi_term LIKE ?',
      whereArgs: ['%$term%'],
    );
  }
}

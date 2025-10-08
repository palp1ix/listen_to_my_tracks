import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// The contract for our local data source.
// The repository will depend on this abstraction, not the concrete implementation.
abstract class SearchHistoryLocalDataSource {
  Future<void> saveSearchTerm(String term);
  Future<List<String>> getSearchHistory();
  Future<void> clearSearchHistory();
}

// The concrete implementation using sqflite.
class SearchHistoryLocalDataSourceImpl implements SearchHistoryLocalDataSource {
  // Constants for database and table details.
  // Keeping them private and constant prevents magic strings elsewhere.
  static const _dbName = 'search_history.db';
  static const _tableName = 'history';
  static const _dbVersion = 1;
  static const _historyLimit = 20; // We only want to store the last 20 search terms.

  // A singleton instance of the database.
  // This prevents opening multiple connections to the database.
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initializes the database, creating it if it doesn't exist.
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // This method is called only once when the database is first created.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        term TEXT NOT NULL UNIQUE,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  @override
  Future<void> saveSearchTerm(String term) async {
    // Sanitize the input term.
    final sanitizedTerm = term.trim();
    if (sanitizedTerm.isEmpty) return;

    final db = await database;

    // 'INSERT OR REPLACE' logic is handled by the conflictAlgorithm.
    // If a term already exists, its row is replaced, effectively updating its timestamp.
    await db.insert(
      _tableName,
      {
        'term': sanitizedTerm,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // After inserting, we trim the history to maintain the defined limit.
    await _trimHistory();
  }

  @override
  Future<List<String>> getSearchHistory() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'timestamp DESC', // Most recent searches first.
      limit: _historyLimit,
    );

    if (maps.isEmpty) {
      return [];
    }

    // Convert the List<Map> to a List<String>.
    return List.generate(maps.length, (i) {
      return maps[i]['term'] as String;
    });
  }

  @override
  Future<void> clearSearchHistory() async {
    final db = await database;
    await db.delete(_tableName);
  }

  // A private helper to remove the oldest entries beyond the history limit.
  Future<void> _trimHistory() async {
    final db = await database;
    // This is an efficient way to delete rows that are not among
    // the most recent `_historyLimit` entries.
    await db.rawDelete('''
      DELETE FROM $_tableName
      WHERE id NOT IN (
        SELECT id FROM $_tableName
        ORDER BY timestamp DESC
        LIMIT $_historyLimit
      )
    ''');
  }
}
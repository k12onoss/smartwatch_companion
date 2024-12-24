import 'package:smartwatch_companion/past_health_records/models/health_record.dart';
import 'package:sqflite/sqflite.dart';

class HealthRecordsRepository {
  static const String _tableName = 'health_records';
  static const String columnId = 'id';
  static const String columnUserId = 'user_id';
  static const String columnTimestamp = 'timestamp';
  static const String columnHeartRate = 'heart_rate';
  static const String columnStepCount = 'step_count';
  static const String columnBloodOxygenLevel = 'blood_oxygen_level';
  static const String columnBodyTemperature = 'body_temperature';

  static String get createTableQuery => '''
    CREATE TABLE $_tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserId TEXT NOT NULL,
        $columnTimestamp INTEGER NOT NULL,
        $columnHeartRate INTEGER,
        $columnStepCount INTEGER,
        $columnBloodOxygenLevel REAL,
        $columnBodyTemperature REAL
    )
  ''';

  HealthRecordsRepository(Database database) : _database = database;

  final Database _database;

  Future<void> insertRecord(HealthRecord record) async {
    await _database.insert(_tableName, record.toMap());
  }

  Future<List<HealthRecord>> getRecordsForUser(String userId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  Future<void> deleteRecord(int id) async {
    await _database.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}

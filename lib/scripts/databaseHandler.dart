import 'package:schuzky_naplno/scripts/programItem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ProgramDatabase {
  static final ProgramDatabase instance = ProgramDatabase._init();
  static Database? _database;

  ProgramDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}programs.db';

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE program_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        time TEXT
      )
    ''');
  }

  Future<void> insertProgramItem(ProgramItem item) async {
    final db = await instance.database;

    await db.insert('program_items', {
      'title': item.nadpisController.text,
      'description': item.popisController.text,
      'time': item.timeController.text,
    });
  }

  Future<List<ProgramItem>> getAllItems() async {
    final db = await instance.database;

    final result = await db.query('program_items');

    return result.map((data) {
      return ProgramItem(
        nadpis: data['title'].toString(),
        popis: data['description'].toString(),
        time: data['time'].toString(),
      );
    }).toList();
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('program_items');
  }
}

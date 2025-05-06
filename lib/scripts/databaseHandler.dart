import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:schuzky_naplno/scripts/programItem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//celej tenhle file vygeneroval chat
class DatabaseHandler {
  static final DatabaseHandler instance = DatabaseHandler._init();
  static Database? _database;

  DatabaseHandler._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'app_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );

    return _database!;
  }

  Future _createDB(Database db, int version) async {
    // program_items
    await db.execute('''
      CREATE TABLE program_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        time TEXT
      )
    ''');

    // plans
    await db.execute('''
      CREATE TABLE plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    // plan_items (many-to-many spojení)
    await db.execute('''
      CREATE TABLE plan_items (
        plan_id INTEGER,
        program_item_id INTEGER,
        FOREIGN KEY (plan_id) REFERENCES plans (id) ON DELETE CASCADE,
        FOREIGN KEY (program_item_id) REFERENCES program_items (id) ON DELETE CASCADE
      )
    ''');
  }

  // --- PROGRAM ITEMY ---
  Future<int> insertProgramItem(ProgramItem item) async {
    final db = await database;

    return await db.insert('program_items', {
      'title': item.nadpisController.text,
      'description': item.popisController.text,
      'time': item.timeController.text,
    });
  }

  Future<List<ProgramItem>> getAllProgramItems() async {
    final db = await database;
    final result = await db.query('program_items');

    return result.map((data) => ProgramItem(
      nadpis: data['title'].toString(),
      popis: data['description'].toString(),
      time: data['time'].toString(),
    )).toList();
  }

  // --- PLÁNY ---
  Future<int> createPlan(String name, List<int> programItemIds) async {
    final db = await database;

    final planId = await db.insert('plans', {'name': name});

    for (var itemId in programItemIds) {
      await db.insert('plan_items', {
        'plan_id': planId,
        'program_item_id': itemId,
      });
    }

    return planId;
  }

  Future<List<ProgramItem>> getProgramItemsForPlan(int planId) async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT program_items.*
      FROM program_items
      JOIN plan_items ON program_items.id = plan_items.program_item_id
      WHERE plan_items.plan_id = ?
    ''', [planId]);

    return result.map((data) => ProgramItem(
        nadpis: data['title'].toString(),
        popis: data['description'].toString(),
        time: data['time'].toString(),
    )).toList();
  }
  
  Future<int> updatePlanName(int planId, String newName) async {
  final db = await database;

  return await db.update(
    'plans',
    {'name': newName},
    where: 'id = ?',
    whereArgs: [planId],
  );
}

  Future<Map<String, List<ProgramItem>>> getAllPlansWithItems() async {
    final db = await database;

    final plans = await db.query('plans');
    Map<String, List<ProgramItem>> result = {};

    for (var plan in plans) {
      final planId = plan['id'] as int;
      final name = plan['name'] as String;

      final items = await db.rawQuery('''
        SELECT program_items.*
        FROM program_items
        JOIN plan_items ON program_items.id = plan_items.program_item_id
        WHERE plan_items.plan_id = ?
      ''', [planId]);

      final itemObjs = items.map((data) => ProgramItem(
        nadpis: data['title'].toString(),
        popis: data['description'].toString(),
        time: data['time'].toString(),
      )).toList();

      result[name] = itemObjs;
    }

    return result;
  }

  // Reset celé databáze (pozor!)
  Future<void> resetDatabase() async {
    final db = await database;
    await db.delete('plan_items');
    await db.delete('plans');
    await db.delete('program_items');
  }
}

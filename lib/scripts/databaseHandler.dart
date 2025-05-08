import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:schuzky_naplno/scripts/planItem.dart';
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

  Future<List<ProgramItem>> getAllProgramItems() async { //unused, možná později
    final db = await database;
    final result = await db.query('program_items');

    return result.map((data) => ProgramItem(
      nadpis: data['title'].toString(),
      popis: data['description'].toString(),
      time: data['time'].toString(),
    )).toList();
  }


  Future<void> updateProgramItems(List<ProgramItem> items) async { //used
    final db = await database; // dostaneš instanci db
    Batch batch = db.batch();  // vytvoříš nový batch

    for (var item in items) {
      batch.update(
        'program_items',              // název tabulky
        {
          'title': item.nadpis,
          'description': item.popis,
          'time': item.time,
        },
        where: 'id = ?',              // najdi podle ID
        whereArgs: [item.id],
      );
    }

    await batch.commit(noResult: true); // proveď vše najednou, nečekáš na výsledky
  }

Future<List<ProgramItem>> upsertProgramItemsWithIdSync(int planId, List<ProgramItem> items) async {
  final db = await database;
  List<ProgramItem> updatedItems = [];

  await db.transaction((txn) async {
    for (var item in items) {
      final data = {
        'title': item.nadpisController.text,
        'description': item.popisController.text,
        'time': item.timeController.text,
      };

      if (item.id != null) {
        // UPDATE existujícího itemu
        await txn.update(
          'program_items',
          data,
          where: 'id = ?',
          whereArgs: [item.id],
        );
        updatedItems.add(item);
      } else {
        // INSERT nového itemu
        int newId = await txn.insert('program_items', data);
        item.id = newId;
        updatedItems.add(item);

        // PÁROVÁNÍ s plánem
        await txn.insert('plan_items', {
          'plan_id': planId,
          'program_item_id': newId,
        });
      }
    }
  });

  return updatedItems;
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

  Future<List<PlanItem>> getAllPlansWithItems() async {
  final db = await database;

  final plans = await db.query('plans');
  List<PlanItem> result = [];

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
      id: data['id'] as int?,
      nadpis: data['title']?.toString() ?? '',
      popis: data['description']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
    )).toList();

    result.add(PlanItem(id: planId, name: name, items: itemObjs));
  }

  return result;
}


  // Reset celé databáze (pozor!)
  Future<void> resetDatabase() async {
    final db = await database;
    await db.delete('plan_items');
    await db.delete('plans');
    await db.delete('program_items');
    print("databáze smazána");
  }
}

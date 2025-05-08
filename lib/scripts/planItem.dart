import 'package:schuzky_naplno/scripts/programItem.dart';

class PlanItem {
  int id;
  String name;
  List<ProgramItem> items;

  PlanItem({
    required this.id,
    required this.name,
    required this.items,
  });
}
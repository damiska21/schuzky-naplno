import 'package:flutter/material.dart';

class ProgramItem {
  int? id; // ← ID z databáze, může být null pro nový item

  final String nadpis;
  final String popis;
  final String time;

  late final TextEditingController nadpisController;
  late final TextEditingController popisController;
  late final TextEditingController timeController;

  ProgramItem({
    this.id, // ← optional
    this.nadpis = '',
    this.popis = '',
    this.time = '',
  }) {
    nadpisController = TextEditingController(text: nadpis);
    popisController = TextEditingController(text: popis);
    timeController = TextEditingController(text: time);
  }

  /// 🧠 Factory z databáze / JSONu
  factory ProgramItem.fromMap(Map<String, dynamic> map) {
    return ProgramItem(
      id: map['id'],
      nadpis: map['title'] ?? '',
      popis: map['description'] ?? '',
      time: map['time'] ?? '',
    );
  }

  /// 🔄 Převod do mapy pro SQL insert/update
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': nadpisController.text,
      'description': popisController.text,
      'time': timeController.text,
    };
  }
}

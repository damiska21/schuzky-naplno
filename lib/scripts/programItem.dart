import 'package:flutter/material.dart';

class ProgramItem {
  final String nadpis;
  final String popis;
  final String time;

  late final TextEditingController nadpisController;
  late final TextEditingController popisController;
  late final TextEditingController timeController;

  ProgramItem({
    this.nadpis = '',
    this.popis = '',
    this.time = '',
  }) {
    nadpisController = TextEditingController(text: nadpis);
    popisController = TextEditingController(text: popis);
    timeController = TextEditingController(text: time);
  }
}

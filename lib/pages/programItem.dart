import 'package:flutter/material.dart';

class ProgramItem {
  TextEditingController nadpisController;
  TextEditingController popisController;
  TextEditingController timeController;

  ProgramItem({String nadpis = '', String popis = '', String time = ''})
      : nadpisController = TextEditingController(text: nadpis),
        popisController = TextEditingController(text: popis),
        timeController = TextEditingController(text: time);
  
}
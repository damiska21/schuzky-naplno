import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schuzky_naplno/scripts/programItem.dart';

class AddProgramScreen extends StatefulWidget {
  final ProgramItem program;
  const AddProgramScreen({super.key, required this.program});

  @override
  State<AddProgramScreen> createState() => _AddProgramScreenState();
}

class _AddProgramScreenState extends State<AddProgramScreen> {
  late TextEditingController nadpisController;
  late TextEditingController popisController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    // Properly initialize the controllers with existing text values
    nadpisController = TextEditingController(text: widget.program.nadpisController.text);
    popisController = TextEditingController(text: widget.program.popisController.text);
    timeController = TextEditingController(text: widget.program.timeController.text);
  }
  @override // Clean up the controller when the widget is disposed.
  void dispose() {
    nadpisController.dispose();
    popisController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  //double screenWidth = MediaQuery.of(context).size.width;
  //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
          title: const Text('Tvorba / úprava programu - programEdit'),
      ),
      body:  Column(
         children:  [ //containry na textový pole
           Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextField(
              autofocus: true,
              controller: nadpisController,
              decoration:  const InputDecoration(
                hintText: 'Běhačka v parku',
                helperText: 'Název Programu',
                border: OutlineInputBorder(),),),
           ),
           Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: popisController,
              textInputAction: TextInputAction.newline,
              decoration:  const InputDecoration(
                hintText: 'Budeme potřebovat pouze míč',
                helperText: 'Popis Programu',
                border: OutlineInputBorder(),),),
           ),
           Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextField(
              controller: timeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:  const InputDecoration(
                hintText: '10',
                helperText: 'Délka Programu (v minutách)',
                border: OutlineInputBorder(),),),
           ),
           ElevatedButton(onPressed: () =>{
            Navigator.pop(context, ProgramItem(nadpis: nadpisController.text, popis: popisController.text, time: timeController.text))}, 
            child: Container(
             margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
             decoration: const BoxDecoration(
               color:  Color.fromARGB(255, 0, 0, 0),
             ),
             child: const Text('Uložit'),
           ))
        ],
      ),
    );
  }

  String getMinuteLabel(String text) {
  int? minutes = int.tryParse(text); // Convert text to int safely
  if (minutes == 1) {
    return "minuta";
  } else if (minutes != null && minutes >= 2 && minutes <= 4) {
    return "minuty";
  } else {
    return "minut";
  }
}
}
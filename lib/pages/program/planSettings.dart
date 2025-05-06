import 'package:flutter/material.dart';

class planSettings extends StatefulWidget {
  const planSettings({super.key});

  @override
  State<planSettings> createState() => _planSettingsState();
}

class _planSettingsState extends State<planSettings> {
  late TextEditingController nadpisController;

  @override
  void initState() {
    super.initState();
    // Properly initialize the controllers with existing text values
    nadpisController = TextEditingController();
  }
  @override // Clean up the controller when the widget is disposed.
  void dispose() {
    nadpisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
          title: const Text('Nastavení plánu - planSettings'),
      ),
      body:  Column(
         children:  [ //containry na textový pole
           Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextField(
              autofocus: true,
              controller: nadpisController,
              decoration:  const InputDecoration(
                hintText: 'Schůzka pondělí',
                helperText: 'Název plánu',
                border: OutlineInputBorder(),),),
           ),
           ElevatedButton(onPressed: () =>{
            Navigator.pop(context, nadpisController.text)}, 
            child: Container(
             margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
             
             child: const Text('Uložit'),
           ))
        ],
      ),
    );
  }
}
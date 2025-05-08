import 'package:flutter/material.dart';
import 'package:schuzky_naplno/scripts/databaseHandler.dart';

class mainSettings extends StatefulWidget {
  const mainSettings({super.key});

  @override
  State<mainSettings> createState() => _mainSettingsState();
}

class _mainSettingsState extends State<mainSettings> {
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
          title: const Text('Nastavení aplikace - mainSettings'),
      ),
      body:  Column(
         children:  [
           ElevatedButton(onPressed: () =>{
            //Navigator.pop(context, nadpisController.text)
            DatabaseHandler.instance.resetDatabase()
            }, 
            child: Container(
             margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
             
             child: const Text('Smazat celou databázi'),
           ))
        ],
      ),
    );
  }
}
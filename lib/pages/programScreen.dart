import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProgramScreen extends StatefulWidget {
  const AddProgramScreen({super.key});

  @override
  State<AddProgramScreen> createState() => _AddProgramScreenState();
}

class _AddProgramScreenState extends State<AddProgramScreen> {
  final nadpisController = TextEditingController();
  final popisController = TextEditingController();
  final timeController = TextEditingController();

  @override // Clean up the controller when the widget is disposed.
  void dispose() {
    nadpisController.dispose();
    popisController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
          title: const Text('Tvorba programu'),
      ),
      body:  Column(
         children:  [
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
            Navigator.pop(context, 

Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
  ),
  child: Row(
    children: [
      Spacer(),
      Column(
        children: [
          Text(nadpisController.text),
          Flexible(child: Text(popisController.text))
        ],
      ),
      Spacer(flex: 2,),
      Column(
        children: [
          Text('čas: ${timeController.text} minut')
        ],
      ),
      Spacer()
    ],
  )
))

           }, 
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
}
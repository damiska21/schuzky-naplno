import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProgramScreen extends StatelessWidget {
  const AddProgramScreen({super.key});

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
            child: const TextField(
            autofocus: true,
            decoration:  InputDecoration(
              hintText: 'Běhačka v parku',
              helperText: 'Název Programu',
              border: OutlineInputBorder(),),),
           ),
           Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: const TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              decoration:  InputDecoration(
                hintText: 'Budeme potřebovat pouze míč',
                helperText: 'Popis Programu',
                border: OutlineInputBorder(),),),
           ),
           Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:  const InputDecoration(
                hintText: '10',
                helperText: 'Délka Programu (v minutách)',
                border: OutlineInputBorder(),),),
           ),
           ElevatedButton(onPressed: () =>{}, 
           child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            
            child: const Text('Uložit'),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
           )
           
           )
        ],
      ),
    );
  }
}
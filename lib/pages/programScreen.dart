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
  //double screenWidth = MediaQuery.of(context).size.width;
  //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
          title: const Text('Tvorba programu'),
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
            Navigator.pop(context, 

Container(
  width: double.infinity, // Ensure it takes full width
  constraints: const BoxConstraints(minHeight: 50), // Minimum height to avoid errors
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
  ),
margin: const EdgeInsets.all(8),
  child: Padding(
    padding: const EdgeInsets.all(8.0), // Padding for better spacing
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align content to top
      children: [
        const Spacer(),
        Expanded( // Ensures text wraps properly inside row
          flex: 3, // Adjust flex value to balance layout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
            children: [
              Text(
                nadpisController.text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4), // Add spacing
              Text(
                popisController.text,
                softWrap: true, // Ensures wrapping
                overflow: TextOverflow.visible, // Ensures text doesn't get clipped
              ),
            ],
          ),
        ),
        const Spacer(flex: 2),
        Expanded( // Prevents layout breaking due to long text
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${timeController.text} minut',
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    ),
  ),
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
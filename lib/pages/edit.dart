import 'package:flutter/material.dart';
import 'package:schuzky_naplno/pages/programItem.dart';

import 'programScreen.dart';

class EditScreen extends StatefulWidget {
  final List<ProgramItem> programyInput;

  const EditScreen({super.key, required this.programyInput});

  @override
  State<EditScreen> createState() => _EditScreen();
}

class _EditScreen extends State<EditScreen> {
  List<ProgramItem> programy = [];
  String getMinuteLabel(String text) {
  int? minutes = int.tryParse(text); // Convert text to int safely
  if (minutes == 1) {
    return "minuta";
  } else if (minutes != null && minutes >= 2 && minutes <= 4) {
    return "minuty";
  } else if(minutes != null){
    return "minut";
  }else{
    return "";
  }
}
  @override
  void initState() {
    super.initState();
    programy = List.from(widget.programyInput); // Correctly assign the input to the state variable
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Plánovač schůzek'),
        ),
        body: programy.isEmpty
            ? const Center(child: Text("Žádné programy. Přidej jeden tlačítkem vpravo dole!"))
            : ReorderableListView.builder(
  itemCount: programy.length,
  onReorder: (oldIndex, newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1; // Adjust for correct positioning
      }
      final item = programy.removeAt(oldIndex);
      programy.insert(newIndex, item);
    });
  },
  itemBuilder: (context, index) {
    final item = programy[index];
    return ListTile(
      key: ValueKey(index), // Important for ReorderableListView
      title: InkWell(
        child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 50),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nadpisController.text,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.popisController.text,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          "${item.timeController.text} ${getMinuteLabel(item.timeController.text)}",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      onTap: () async { 
        final cont = await Navigator.push( context,
          MaterialPageRoute(builder: (context) => AddProgramScreen(program: ProgramItem(nadpis: programy[index].nadpisController.text, popis: programy[index].popisController.text, time: programy[index].timeController.text))),
        );
        if (cont != null && cont is ProgramItem) {
          setState(() {  programy.removeAt(index); programy.insert(index, cont); });
        }
    },
),
      
      leading: ReorderableDragStartListener(
        index: index,
        child: const Icon(Icons.drag_handle),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          setState(() {
            programy.removeAt(index);
          });
        },
      ),
    );
  },
),
        floatingActionButton: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () async {
                  final cont = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProgramScreen(program: ProgramItem())),
                  );
                  if (cont != null && cont is ProgramItem) {
                    setState(() { programy.add(cont); });
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                child: Icon(Icons.save),
                onPressed: () async {
                Navigator.pop(context, programy);
              }),
            )
          ],
        )
      ),
    );
  }
  
}
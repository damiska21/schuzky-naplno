import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'pages/programScreen.dart';

void main() {
  runApp(
    MaterialApp(
      home:  MyApp(storage: Storage()),
      routes: <String, WidgetBuilder>{
        "/editProgram": (BuildContext context) => const AddProgramScreen(),
      },
    ),
  );
}
class Storage { //zdroj: https://docs.flutter.dev/cookbook/persistence/reading-writing-files
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.txt');
  }
  Future<int> read() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }
  Future<File> write(List<Container> programy) async {
    final file = await _localFile;
    return file.writeAsString('$programy');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.storage});

  final Storage storage;
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Container> programy = [];

  Future<File> _saveProgramy() {
    return widget.storage.write(programy);
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
            : ReorderableListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [ //zobrazení programů
                  for (int index = 0; index < programy.length; index++)
                    ListTile(
                      key: ValueKey(index),
                      title: programy[index],
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
                    ),
                ],
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = programy.removeAt(oldIndex);
                    programy.insert(newIndex, item);
                  });
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
              MaterialPageRoute(builder: (context) => const AddProgramScreen()),
            );
            if (cont != null && cont is Container) {
              setState(() {
                programy.add(cont);
              });
            }
          },
        ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(onPressed: _saveProgramy),
            )
          ],
        )
        
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:convert';
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
  Future<String> read() async {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
  }
  Future<File> write(String programy) async {
    final file = await _localFile;
    return file.writeAsString(programy);
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
    return widget.storage.write(serializeContainers(programy));
  }

String serializeContainers(List<Container> containers) {
  List<Map<String, String>> containerData = [];

  for (var container in containers) {
    var column = (container.child as Padding).child as Row;
    var expanded = column.children.last as Expanded;
    var columnInside = expanded.child as Column;
    var textWidgets = columnInside.children.whereType<Text>().toList();

    containerData.add({
      "title": textWidgets[0].data ?? "",
      "description": textWidgets[1].data ?? "",
      "time": textWidgets[2].data ?? "",
    });
  }

  return jsonEncode(containerData); // Convert to JSON string
}
List<Container> deserializeContainers(String jsonString) {
  List<dynamic> decodedData = jsonDecode(jsonString);

  return decodedData.map((data) {
    return Container(
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
                    data["title"] ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data["description"] ?? "",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                  Text(
                    "${data["time"] ?? ""} ${getMinuteLabel(data["time"] ?? "")}",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }).toList();
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
  
@override
  void initState() {
    super.initState();
    widget.storage.read().then((value) {
      setState(() {
        programy = deserializeContainers(value);
      });
    });
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
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(onPressed: _saveProgramy),
            )
          ],
        )
        
      ),
    );
  }
}

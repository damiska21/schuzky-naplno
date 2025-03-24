import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'pages/edit.dart';
import 'package:planovac/pages/programItem.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(/*storage: Storage()*/),
      routes: <String, WidgetBuilder>{
        "/program": (BuildContext context) =>
            const EditScreen(programyInput: []),
      },
    ),
  );
}

class Storage {
  //zdroj: https://docs.flutter.dev/cookbook/persistence/reading-writing-files
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
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ProgramItem> programy = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Přehled schůzek'),
        ),
        body: programy.isEmpty
            ? const Center(
                child: Text(
                  "Žádné programy. Přejdi do režimu úpravy a jeden přidej!",
                ),
              )
            : ListView.builder(
                itemCount: programy.length,
                itemBuilder: (context, index) {
                  final item = programy[index];
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
                                  item.nadpisController.text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.popisController.text,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                child: const Icon(Icons.edit),
                onPressed: () async {
                  final cont = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(programyInput: programy),
                    ),
                  );
                  if (cont != null && cont is List<ProgramItem>) {
                    setState(() {});
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

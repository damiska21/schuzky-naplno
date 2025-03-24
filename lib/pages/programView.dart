import 'dart:convert';
import 'package:flutter/material.dart';
import 'edit.dart';
import 'package:planovac/pages/programItem.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(/*storage: Storage()*/),
      routes: <String, WidgetBuilder>{
        "/edit": (BuildContext context) => const EditScreen(programyInput: []),
      },
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  //final Storage storage;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ProgramItem> programy = [];
  String serializeProgramItems(List<ProgramItem> items) {
    List<Map<String, String>> serializedData =
        items.map((item) {
          return {
            "title": item.nadpisController.text,
            "description": item.popisController.text,
            "time": item.timeController.text,
          };
        }).toList();

    return jsonEncode(serializedData);
  }

  List<ProgramItem> deserializeProgramItems(String jsonString) {
    List<dynamic> decodedData = jsonDecode(jsonString);

    return decodedData.map((data) {
      return ProgramItem(
        nadpis: data["title"] ?? "",
        popis: data["description"] ?? "",
        time: data["time"] ?? "",
      );
    }).toList();
  }

  String getMinuteLabel(String text) {
    int? minutes = int.tryParse(text); // Convert text to int safely
    if (minutes == 1) {
      return "minuta";
    } else if (minutes != null && minutes >= 2 && minutes <= 4) {
      return "minuty";
    } else if (minutes != null) {
      return "minut";
    } else {
      return "";
    }
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
        body:
            programy.isEmpty
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
                                  Text(
                                    "${item.timeController.text} ${getMinuteLabel(item.timeController.text)}",
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
                    setState(() {
                      programy = cont;
                    });
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

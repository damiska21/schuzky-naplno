import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schuzky_naplno/pages/program/editScreen.dart';
import 'package:schuzky_naplno/pages/program/planSettings.dart';
import 'package:schuzky_naplno/scripts/programItem.dart';

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

class planScreen extends StatefulWidget {
  const planScreen({super.key});

  @override
  State<planScreen> createState() => _planScreen();
}


class _planScreen extends State<planScreen> {
  List<ProgramItem> programy = [];

  /*Future<File> _saveProgramy() {
    return widget.storage.write(serializeProgramItems(programy));
  }*/

String serializeProgramItems(List<ProgramItem> items) {
  List<Map<String, String>> serializedData = items.map((item) {
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
  } else if(minutes != null){
    return "minut";
  }else{
    return "";
  }
}

@override
  void initState() {
    super.initState();
    /*widget.storage.read().then((value) {
      setState(() {
        programy = deserializeProgramItems(value);
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.blue,
          title: const Text('Plánovač - planScreen'), //schůzekr
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
        // otevři nastavení nebo jinou stránku
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => planSettings()),
                );
              },
            ),
          ],
        ),
        body: programy.isEmpty
            ? const Center(child: Text("Žádné bloky programů. Přejdi do režimu úpravy a jeden přidej!"))
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
              MaterialPageRoute(builder: (context) => EditScreen(programyInput: programy,)),
            );
            if (cont != null && cont is List<ProgramItem>) {
              setState(() {
                programy = cont;
              });
            }
          },
        ),
            )
          ],
        )
      ),
    );
  }
}

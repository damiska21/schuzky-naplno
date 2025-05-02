import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:schuzky_naplno/pages/program/editScreen.dart';
import 'package:schuzky_naplno/pages/program/programScreen.dart';
import 'package:schuzky_naplno/scripts/storageService.dart';
import 'package:schuzky_naplno/scripts/programItem.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//zprovozňuje StorageService
  await StorageService().init();

  runApp(
    MaterialApp(
      home:  MyApp(),
      routes: <String, WidgetBuilder>{
        "/edit": (BuildContext context) => const programScreen(),
      },
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  List<ProgramItem> plany = [];

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
Future<void> loadAllUserJsons() async {
  final dir = await getApplicationDocumentsDirectory();
  final jsonDir = Directory('${dir.path}/user_jsons');

  if (!jsonDir.existsSync()) {
    print('🔍 Žádnej JSON adresář neexistuje ještě');
    return;
  }

  final files = jsonDir
      .listSync(recursive: true)
      .where((file) => file is File && file.path.endsWith('.json'));

  for (var file in files) {
    final content = (file as File).readAsStringSync();
    final json = jsonDecode(content);
    print('🧾 ${file.path}');
    print(json);
    plany.add(deserializeProgramItems(json).first);
  }
}

@override
  void initState() {
    super.initState();
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
        body: plany.isEmpty
            ? const Center(child: Text("Žádné programy. Vytvoř třeba schůzku tlačítkem dole!"))
            : ListView.builder(
  itemCount: plany.length,
  itemBuilder: (context, index) {
    final item = plany[index];
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

        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_box_rounded),
          onPressed: () async {
            final cont = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditScreen(programyInput: plany,)),
            );
            if (cont != null && cont is List<ProgramItem>) {
              setState(() {
                plany = cont;
              });
            }
          },
        ),
      ),
    );
  }
}

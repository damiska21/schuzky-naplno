import 'package:flutter/material.dart';
import 'package:schuzky_naplno/pages/mainSettings.dart';
import 'package:schuzky_naplno/pages/program/planScreen.dart';
import 'package:schuzky_naplno/scripts/databaseHandler.dart';
import 'package:schuzky_naplno/scripts/planItem.dart';
import 'package:schuzky_naplno/scripts/storageService.dart';
import 'package:schuzky_naplno/scripts/programItem.dart';

/*terminologie 
program - jeden kus, jedna aktivita
plán - několik programů u sebe, např. na celý den
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();//zprovozňuje StorageService
  await StorageService().init();

  runApp(
    MaterialApp(
      home:  MyApp(),
      routes: <String, WidgetBuilder>{
        "/edit": (BuildContext context) => const planScreen(planId: -1,),
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
  List<PlanItem> plany = [];


@override
  void initState() {
    super.initState();
    fetchPlany();
  }

  void fetchPlany()async{
    plany = await DatabaseHandler.instance.getAllPlansWithItems();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Plánovač schůzek - main'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => mainSettings()),
                );
                setState(() {});
              },
            ),
          ],
        ),
        body: plany.isEmpty
    ? const Center(child: Text("Žádné plány. Přidej nějaký pomocí tlačítka dole!"))
    : ListView.builder(
        itemCount: plany.length,
        itemBuilder: (context, index) {
          final plan = plany[index];
          return GestureDetector(
            onTap: () {
              // Otevře detail plánu (např. programy v něm)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => planScreen(planId: plan.id),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 50),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  plan.name + plan.id.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
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
              MaterialPageRoute(builder: (context) => planScreen(planId: -1,)),
            );
            if (cont != null && cont is List<ProgramItem>) {
              setState(() {
                //plany = cont;
              });
            }
          },
        ),
      ),
    );
  }
}

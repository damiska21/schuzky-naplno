import 'package:flutter/material.dart';
import 'pages/programScreen.dart';

void main() {
  runApp(
    MaterialApp(
      home: const MyApp(),
      routes: <String, WidgetBuilder>{
        "/editProgram": (BuildContext context) => const AddProgramScreen(),
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
  List<Container> programy = [];

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
                children: [
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
        floatingActionButton: FloatingActionButton(
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
    );
  }
}

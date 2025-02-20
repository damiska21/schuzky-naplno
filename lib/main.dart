import 'package:flutter/material.dart';
import 'pages/programScreen.dart';
void main() {
  runApp( 
    MaterialApp(
    home: const MyApp(),
    routes: <String, WidgetBuilder>{
      "/editProgram" : (BuildContext context)=> const AddProgramScreen(),
      //add more routes here
    },
));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Container> programy = [];
  @override
  //build se volá vždycky když rebilduješ appku
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Schůzky naplno!'),
        ),
        body: Column(
          children: programy,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            //addProgram();
            final cont = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddProgramScreen()),);
            setState(() {
              programy.add(cont);
            });
            //print(cont);
            //print(programy);
          },
        ),
      ),
    );
  }
}
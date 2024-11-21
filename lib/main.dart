import 'package:flutter/material.dart';
import 'pages/programScreen.dart';
void main() {
  runApp( 
    new MaterialApp(
    home: MyApp(),
    routes: <String, WidgetBuilder>{
      "/editProgram" : (BuildContext context)=> AddProgramScreen(),
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
  void addProgram(){
    setState(() {
      programy.add(
Container(
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
  ),
  child: const Row(
    children: [
      Spacer(),
      Column(
        children: [
          Text('sloupec 1'),
          Text('sloupec 1')
        ],
      ),
      Spacer(flex: 2,),
      Column(
        children: [
          Text('sloupec 2'),
          Text('sloupec 2')
        ],
      ),
      Spacer()
    ],
  )
)
      );
    });
  }
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
            print(cont);
          },
        ),
      ),
    );
  }
}
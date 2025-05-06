import 'package:flutter/material.dart';
import 'package:schuzky_naplno/pages/program/editScreen.dart';
import 'package:schuzky_naplno/pages/program/planSettings.dart';
import 'package:schuzky_naplno/scripts/programItem.dart';
import 'package:schuzky_naplno/scripts/databaseHandler.dart';


class planScreen extends StatefulWidget {
  final int planId; //pokud je to -1, znamená, že to je fresh a je nutné vytvořit záznam
  const planScreen({super.key, required this.planId});

  @override
  State<planScreen> createState() => _planScreen();
}

class _planScreen extends State<planScreen> {
  List<ProgramItem> programy = [];
  String nazev = "";
  int planId = -2;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      programyInitialize();
    });
  }

  void programyInitialize()async{
  //buďto vytvoří nový záznam plánu, nebo loadne starý záznam plánu
    planId = widget.planId;
    if (planId == -1) {
      nazev = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => planSettings()),
                );
      planId = await DatabaseHandler.instance.createPlan(nazev, []);
    }else{
      programy = await DatabaseHandler.instance.getProgramItemsForPlan(planId);
      setState(() {});
    }
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
          title: const Text('Plánovač - planScreen'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                final nazevChange = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => planSettings()),
                );
                if (nazevChange != null && nazevChange is String) {
          setState(() async { nazev = nazevChange; await DatabaseHandler.instance.updatePlanName(planId, nazev); });}
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
              MaterialPageRoute(builder: (context) => EditScreen(programyInput: programy, planId: planId,)),
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

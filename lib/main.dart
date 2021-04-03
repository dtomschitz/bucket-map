import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:toggle_bar/toggle_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoApp(),
    );
  }
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  List<String> labels = ['Map', 'List'];
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Toggle Bar'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ToggleBar(
              labels: labels,
              textColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              selectedTabColor: Colors.purpleAccent,
              labelTextStyle: TextStyle(fontWeight: FontWeight.bold),
              onSelectionUpdated: (index) {
                setState(() {
                  counter = index;
                });
              }
              ),
            SizedBox(height: 200,),
            Text(labels[counter], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 50, color: Colors.black),),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: Icon(Icons.flag),
            label: "add Country",
            onTap: () => print("new Country"),
          ),
          SpeedDialChild(
            child: Icon(Icons.push_pin),
            label: "add Pin",
            onTap: () => print("new Pin"),
          )
        ],
      ),
    );
  }
}

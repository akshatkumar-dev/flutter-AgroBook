import 'package:flutter/material.dart';
void main()=>runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.red
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Agro Book"),
        ),
      )
    );
  }
}
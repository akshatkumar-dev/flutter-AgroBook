import 'package:flutter/material.dart';
import './show_products.dart';
import './drawer_content.dart';
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
        drawer: Drawer(
          child: DrawerContent()
        ),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){},
            )
          ],
          title: Text("Agro Book"),
        ),
      body: RefreshIndicator(
              onRefresh: (){},
              child: ListView(
            children: <Widget>[
              ShowProduct(),
              ShowProduct(),
              ShowProduct(),
              ShowProduct(),
              ShowProduct(),
              ShowProduct()
            ],
          ),
      ),
      ),
    );
  }
}
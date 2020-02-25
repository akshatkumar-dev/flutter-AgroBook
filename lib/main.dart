import 'package:flutter/material.dart';
import './show_products.dart';
import './drawer_content.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main()=>runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var data;
  var parseData = [];
  var isLoading = true;
  Future<void> fetchData() async{
    //if(data.length != 0){data.clear();}
    if(parseData.length!=0){parseData.clear();}
    const DATABASE_URL = "https://agro-book.firebaseio.com/seller.json";
    var response = await http.get(DATABASE_URL);
    data = json.decode(response.body);
    data.forEach((key,value){
      parseData.add(value);
    });
    setState(() {
      isLoading = false;
    });
    return;
  }
  
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }
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
      body: isLoading? Center(child:CircularProgressIndicator()): RefreshIndicator(
              onRefresh: fetchData,
              child: ListView(
            children: <Widget>[
              ...parseData.map((value){
                return ShowProduct(value["title"],value["subtitle"],double.parse(value["price"]));
              })
              // ShowProduct("Product Title","Subtitle",123.0),
              // ShowProduct("Product Title","Subtitle",123.0),
              // ShowProduct("Product Title","Subtitle",12.3),
              // ShowProduct("Product Title","Subtitle",12.3),
              // ShowProduct("Product Title","Subtitle",123.0),
              // ShowProduct("Product Title","Subtitle",12.3),
              // ShowProduct("Product Title","Subtitle",1.23)
            ],
          ),
      ),
      ),
    );
  }
}
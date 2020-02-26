import 'package:flutter/material.dart';
import './show_products.dart';
import './drawer_content.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './register_screen.dart';
void main()=>runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var data;
  var parseData = [];
  var isLoading = true;
  var isLoggedIn = false;
  Future<void> fetchData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("isLoggedIn");
    setState(() {
          isLoggedIn = pref.getBool("isLoggedIn") ?? false;
    });
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
          child: DrawerContent(isLoggedIn)
        ),
        appBar: AppBar(
          actions: !isLoggedIn?<Widget>[
            Builder(
                builder:(context)=> IconButton(
                icon: Icon(Icons.perm_identity),
                onPressed: () async{
                  var x = await Navigator.of(context).push(MaterialPageRoute(builder: (_){
                      return RegisterScreen();
                  }));
                  setState(() {
                    isLoggedIn = x;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){},
            )
          ]:<Widget>[
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
            ],
          ),
      ),
      ),
    );
  }
}
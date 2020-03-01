import 'dart:async';
import './helper/helper_functions.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  //StorageReference productImage;
  @override
  void initState() {
    HelperFunctions().fetchAllProducts();
    //productImage = FirebaseStorage.instance.ref();
    
    // TODO: implement initState
    super.initState();
    
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  var randomController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: randomController,
            decoration: InputDecoration(labelText: "User"),
          ),
          RaisedButton(
            onPressed: (){
              //sellerRef.push().set(<String,String>{"hello":"random","blabla":"ahahaha"}); 
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
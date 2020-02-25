import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MainSellerScreen extends StatefulWidget {
  @override
  _MainSellerScreenState createState() => _MainSellerScreenState();
}

class _MainSellerScreenState extends State<MainSellerScreen> {
  var titleController = TextEditingController();  
  var subTitleController = TextEditingController();  
  var priceController = TextEditingController();  
  var isLoading = false;
  static const DATABASE_URL = "https://agro-book.firebaseio.com/seller.json";
  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
      body: isLoading?Center(child:CircularProgressIndicator()):Text(""),
      appBar: AppBar(
        title: Text("Seller Screen"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showModalBottomSheet(context: context, builder: (builder){
            return Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: "Item title"),
                    controller: titleController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Item Subtitle"),
                    controller: subTitleController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Price Per KG"),
                    controller: priceController,
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(top:16),
                    child: RaisedButton(
                      child: Text("Upload Data"),
                      onPressed: (){
                        var toSend = {
                          "title": titleController.text,
                          "subtitle":subTitleController.text,
                          "price":priceController.text
                        };
                        if(toSend["title"].length!=0 && toSend["subtitle"].length!=0 && toSend["price"].length!=0)
                        {
                        setState(() {
                          isLoading = true;
                        });
                          Navigator.pop(context);

                        http.post(DATABASE_URL,body:json.encode(toSend)).then((_){
                          setState(() {
                            isLoading = false;
                          });
                        }).catchError((onError){print(onError);});
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    ));
    
  }
}
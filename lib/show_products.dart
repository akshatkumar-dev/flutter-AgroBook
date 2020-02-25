import 'package:flutter/material.dart';

class ShowProduct extends StatefulWidget {
  var title = "something";
  var subtile = "some subtitle";
  var price = 123.0;

  ShowProduct(String ti,String sub,double pric){
    title = ti;
    subtile = sub;
    price = pric;
  }
  @override
  _ShowProductState createState() => _ShowProductState(title,subtile,price);
  
}

class _ShowProductState extends State<ShowProduct> {
  var title = "something";
  var subtile = "some subtitle";
  var price = 123.0;
  _ShowProductState(String ti,String sub,double pric){
    title = ti;
    subtile = sub;
    price = pric;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network("https://i.ytimg.com/vi/F_B0yx-4I2Y/maxresdefault.jpg"),
          title: Text(title),
          subtitle: Text(subtile),
          trailing: Text(price.toString()),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ShowProduct extends StatefulWidget {
  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network("https://i.ytimg.com/vi/F_B0yx-4I2Y/maxresdefault.jpg"),
          title: Text("SomeRandomTitle"),
          subtitle: Text("probably vendor name"),
          trailing: Text("price"),
        ),
      ),
    );
  }
}
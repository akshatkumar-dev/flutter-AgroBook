import 'package:flutter/material.dart';
import './main_seller_screen.dart';
import './test_firebase.dart';

class DrawerContent extends StatefulWidget {
  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.only(top: 16.0),
            child: Text(
              "Heading",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.supervised_user_circle),
            title: Text("Buyer Portal"),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return MainSellerScreen();
              }));
            },
            leading: Icon(Icons.supervised_user_circle),
            title: Text("Seller Portal"),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return TestWidget();
              }));
            },
            leading: Icon(Icons.rate_review),
            title: Text("Rate Us"),
          )
        ],
      ),
    );
  }
}

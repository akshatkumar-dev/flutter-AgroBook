import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './main.dart';
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const DATABASE_URL = "https://agro-book.firebaseio.com/users.json";
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false;
  Future<void> setLogin() async{
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    var id = await http.post(DATABASE_URL,body: json.encode({"email":emailController.text,"password":passwordController.text}));
    var x = json.decode(id.body);
    await prefs.setString("key", x["name"].toString());
    return;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: isLoading?Center(child:CircularProgressIndicator()):SingleChildScrollView(
              child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("Enter email and password to register\nIf it already exists then you will be logged in",
                style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email"
                ),
                controller: emailController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Password"
                ),
                controller: passwordController,
                obscureText: true,
              ),
              FlatButton(
                splashColor: Colors.red,
                child: Text("Register/Login"),
                onPressed: () async{
                  if(emailController.text.length!=0 && passwordController.text.length!=0){
                    await setLogin();
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context,true);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
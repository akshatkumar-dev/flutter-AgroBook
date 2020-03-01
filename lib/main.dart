import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './drawer_content.dart';
import './helper/helper_functions.dart';
import './helper/product_model.dart';
import './product_details_screen.dart';
import './view_cart_screen.dart';
import './all_buyer_transactions.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"/cart": (context) => ViewCartScreen()},
      theme: ThemeData(primarySwatch: Colors.green, accentColor: Colors.red),
      home: Home()
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> productList;
  var isLoading = true;
  @override
  void initState() {
    HelperFunctions().initializeId();
    HelperFunctions().fetchAllProducts().then((List<Product> value) {
      setState(() {
        isLoading = false;
        productList = value;
      });
    });
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    HelperFunctions.height = MediaQuery.of(context).size.height;
    HelperFunctions.width = MediaQuery.of(context).size.width;
    var width = HelperFunctions.width;
    return Scaffold(
        drawer: Drawer(child: DrawerContent()),
        appBar: AppBar(title: Text("Agro Book"), actions: <Widget>[
          Builder(
            builder: (ctxx) => IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () async {
                Navigator.of(ctxx).push(MaterialPageRoute(builder: (ctx) {
                  return ViewCartScreen();
                }));
              },
            ),
          ),
          productList == null
              ? IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    var newValue = await HelperFunctions().fetchAllProducts();
                    setState(() {
                      isLoading = false;
                      productList = newValue;
                    });
                  },
                )
              : Text(""),
          Builder(
            builder: (ctxx) => IconButton(
              icon: Icon(Icons.monetization_on),
              onPressed: () {
                Navigator.of(ctxx).push(MaterialPageRoute(builder: (ctx) {
                  return AllBuyerTransactions();
                }));
              },
            ),
          )
        ]),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  var newValue = await HelperFunctions().fetchAllProducts();
                  setState(() {
                    productList = newValue;
                  });
                  return;
                },
                child: productList == null
                    ? Center(
                        child: Text("No products available"),
                      )
                    : ListView.builder(
          itemCount: productList.length,
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                  return ProductDetailsScreen(productList[i]);
                }));
              },
                          child: Card(
                child: (Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Container(
                    width: width / 3,
                
                    margin: EdgeInsets.only(right: 10),
                    child: productList[i].imageUrl.length == 0
                                          ? Image.asset(
                                              "assets/images/noimage.jpg",
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: productList[i].imageUrl,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                            ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Text(
                          productList[i].title,
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Container( margin: EdgeInsets.only(bottom:8),child: Text(productList[i].stock.toString())),
                        Text(
                          "₹ "+ productList[i].price.toString(),
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        )
                      ],
                    ),
                  )
                ])),
              ),
            );
          }),),
      );
  }
}

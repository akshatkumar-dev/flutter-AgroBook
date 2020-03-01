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
    return MaterialApp(
      routes: {"/cart": (context) => ViewCartScreen()},
      theme: ThemeData(primarySwatch: Colors.green, accentColor: Colors.red),
      home: Scaffold(
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
                              splashColor: Colors.green,
                              onTap: () {
                                Navigator.of(ctx)
                                    .push(MaterialPageRoute(builder: (ctxx) {
                                  return ProductDetailsScreen(productList[i]);
                                }));
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: productList[i].imageUrl.length == 0
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
                                    title: Text(productList[i].title),
                                    subtitle:
                                        Text(productList[i].stock.toString()),
                                    trailing:
                                        Text(productList[i].price.toString()),
                                  ),
                                ),
                              ));
                        },
                      )),
      ),
    );
  }
}

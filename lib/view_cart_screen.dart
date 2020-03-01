import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './helper/helper_functions.dart';
import './helper/product_model.dart';
import './checkout_screen.dart';

class ViewCartScreen extends StatefulWidget {
  @override
  _ViewCartScreenState createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends State<ViewCartScreen> {
  List<Product> products;
  var isLoading = true;
  double totalPrice = 0;
  _ViewCartScreenState();

  Future<void> confirmDialog(String productId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                });
                var x = await HelperFunctions().removeItemsFromCart(productId);
                setState(() {
                  products = x;
                  totalPrice = HelperFunctions().calculateTotalPrice(products);
                  isLoading = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    HelperFunctions().getAllCartItems().then((cart) {
      setState(() {
        totalPrice = HelperFunctions().calculateTotalPrice(cart);
        isLoading = false;
        products = cart;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = HelperFunctions.width;
    return Scaffold(
        appBar: AppBar(title: Text("Cart"), actions: <Widget>[
          products == null
              ? IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    var x = await HelperFunctions().getAllCartItems();
                    setState(() {
                      isLoading = false;
                      products = x;
                      totalPrice =
                          HelperFunctions().calculateTotalPrice(products);
                    });
                  },
                )
              : Text("")
        ]),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  var x = await HelperFunctions().getAllCartItems();
                  setState(() {
                    products = x;
                    totalPrice =
                        HelperFunctions().calculateTotalPrice(products);
                  });
                },
                child: products == null
                    ? Center(
                        child: Text("Cart is Empty"),
                      )
                    : Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (ctx, i) {
            return Dismissible(
              key: Key(products[i].id),
              background: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Container(padding: EdgeInsets.all(10),margin: EdgeInsets.all(10),child: Icon(Icons.delete)), Container(padding: EdgeInsets.all(10),margin: EdgeInsets.all(10),child: Icon(Icons.delete))],
                  )),
                  onDismissed: (direction) async {
                    setState(() {
                  isLoading = true;
                });
                var x = await HelperFunctions().removeItemsFromCart(products[i].id);
                setState(() {
                  products = x;
                  totalPrice = HelperFunctions().calculateTotalPrice(products);
                  isLoading = false;
                });
                  },
                          child: Card(
                child: (Row
                (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  
                  Container(
                    width: width / 3,
                    margin: EdgeInsets.only(right: 10),
                    child: products[i].imageUrl.length == 0
                                          ? Image.asset(
                                              "assets/images/noimage.jpg",
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: products[i].imageUrl,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                            ),
                  ),
                  Container(
                    width: width/3,
                    child: Text(
                      products[i].title,
                      softWrap: true,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10,bottom:10),
                    margin: EdgeInsets.only(left: 5),
                    child: Column(
                      children: <Widget>[
                        Text("₹ "+products[i].price.toString(),softWrap: true,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        Text("x "+products[i].quantity.toString(),softWrap: true,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                        Text("₹ "+(products[i].price*products[i].quantity).toString(),softWrap:true,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.red),)
                      ],
                    ),
                  )
                ])),
              ),
            );
          }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    
                                      "Total Price: ₹ " + totalPrice.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)),
                              RaisedButton(
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration:
                                      BoxDecoration(color: Colors.green),
                                  child: Text("Checkout"),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return CheckoutScreen(products,totalPrice.toString());
                                  }));
                                },
                              )
                            ],
                          )
                        ],
                      ),
              ));
  }
}

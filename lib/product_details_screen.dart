import 'package:agro_book/checkout_screen.dart';
import 'package:agro_book/view_cart_screen.dart';
import 'package:flutter/material.dart';
import './helper/product_model.dart';
import './helper/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  Product first;
  ProductDetailsScreen(this.first);
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState(first);
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product product;
  var isUploading = false;
  var quantityController = TextEditingController(text: "1");
  _ProductDetailsScreenState(this.product);
  @override
  Widget build(BuildContext context) {
    var height = HelperFunctions.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Builder(
            builder: (ctx) => IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.green,
              onPressed: () {
                Navigator.of(ctx).push(MaterialPageRoute(builder: (ctxx) {
                  return ViewCartScreen();
                }));
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          product.imageUrl.length == 0
              ? Image.asset(
                  "assets/images/noimage.jpg",
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: product.imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                ),
          Column(
            children: <Widget>[
              Container(
                height: height / 2.3,
                child: Text(""),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  child: Container(
                      height: height - height / 2.3,
                      width: double.infinity,
                      color: Colors.white,
                      child: Container(
                          height: height - height / 2.3,
                          width: double.infinity,
                          child: ListView(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(16),
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      product.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "₹ "+product.price.toString(),
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 20),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    product.description,
                                    softWrap: true,
                                  )),
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                        "InStock: " + product.stock.toString()),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: TextField(
                                          controller: quantityController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(

                                              labelText: "Order Stock"),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Builder(
                                                              builder:(ctx)=> ButtonBar(children: <Widget>[
                                                                            isUploading?CircularProgressIndicator():Text(""),

                                  FlatButton(
                                    child: Text("Add to Cart"),
                                    onPressed: () async {
                                      setState(() {
                                        isUploading = true;
                                      });
                                      if (double.parse(quantityController.text) <=
                                              product.stock &&
                                          double.parse(quantityController.text) >
                                              0) {
                                        product.setQuantity(double.parse(
                                            quantityController.text));
                                        await HelperFunctions().addItemToCart(
                                            product.id, product.quantity);
                                        setState(() {
                                          isUploading = false;
                                          Scaffold.of(ctx)
                                              .showSnackBar(SnackBar(
                                            content: Text("Added to cart"),
                                          ));
                                        });
                                      } else {
                                        setState(() {
                                          isUploading = false;
                                          Scaffold.of(ctx)
                                              .showSnackBar(SnackBar(
                                            content: Text("Invalid stock"),
                                          ));
                                        });
                                      }
                                    },
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      if (double.parse(quantityController.text) <=
                                              product.stock &&
                                          double.parse(quantityController.text) >
                                              0) {
                                        product.setQuantity(double.parse(
                                            quantityController.text));
                                        Navigator.of(ctx).push(MaterialPageRoute(builder: (ctxx){
                                          var products = List<Product>();
                                          products.add(product);
                                          var totalPrice = product.price * product.quantity;
                                          return CheckoutScreen(products,totalPrice.toString());
                                        }));
                                    }
                                    else{
                                      Scaffold.of(ctx).showSnackBar(SnackBar(content:Text("Invalid Quantity")));
                                    }
                                    },
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: const Text('Buy Now',
                                          style: TextStyle(fontSize: 20)),
                                    ),
                                  ),
                                ]),
                              )
                            ],
                            padding: EdgeInsets.all(0),
                          )))),
            
            ]
            ,
          ),
        ]),
      ),
    );
  }
}

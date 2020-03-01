import 'package:agro_book/helper/address_model.dart';
import 'package:agro_book/helper/helper_functions.dart';
import 'package:agro_book/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './display_address.dart';
import './helper/product_model.dart';
class FinalPlaceOrderScreen extends StatefulWidget {
  List<Product> products;
  Address delivery;
  FinalPlaceOrderScreen({this.products,this.delivery});
  @override
  _FinalPlaceOrderScreenState createState() => _FinalPlaceOrderScreenState(deliveryAddress: delivery,orderProducts: products);
}

class _FinalPlaceOrderScreenState extends State<FinalPlaceOrderScreen> {
  Address deliveryAddress;
  List<Product> orderProducts;
  var isLoading = false;
  _FinalPlaceOrderScreenState({this.deliveryAddress,this.orderProducts});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final Order"),
      ),
      body: isLoading?Center(child: Column(children: <Widget>[
        Text("Processing request do not go back..."),
        CircularProgressIndicator()
      ],),):Container(
        child: Column(
          children: <Widget>[
            Text("Delivery To:"),
            DisplayAddress(deliveryAddress),
            Expanded(
              child: ListView.builder(
                itemCount: orderProducts.length,
                itemBuilder: (ctx,i){
                  
                  Address shippinAddress = Address();
                  shippinAddress.decodeAddress(orderProducts[i].shippingAdress);
                  return (Container(
                    child: Card(
                            child: Column(
                        children: <Widget>[
                          orderProducts[i].imageUrl.length==0?
                Image.asset("assets/images/noimage.jpg",width: double.infinity,height: 200): 
                CachedNetworkImage(
                  width: double.infinity,
                  height: 200,
                  imageUrl: orderProducts[i].imageUrl,
                  placeholder: (context,url)=>CircularProgressIndicator(),),
                  Text(orderProducts[i].title),
                  Text("Delivery from:"),
                  DisplayAddress(shippinAddress)
                        ],
                      ),
                    ),
                  ));
                }
                ),
            ),
            RaisedButton(
                    textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(color: Colors.green),
                                  child: Text("Place order"),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                    await HelperFunctions().purchaseProduct(orderProducts);
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: 
                                    (ctx){
                                      return MyApp();
                                    }
                                    ), ModalRoute.withName("/"));
                                },),
          ],
        ),
      ),
    );
  }
}
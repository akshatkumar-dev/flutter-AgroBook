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
  String total;
  FinalPlaceOrderScreen({this.products,this.delivery,this.total});
  @override
  _FinalPlaceOrderScreenState createState() => _FinalPlaceOrderScreenState(deliveryAddress: delivery,orderProducts: products,tot:total);
}

class _FinalPlaceOrderScreenState extends State<FinalPlaceOrderScreen> {
  Address deliveryAddress;
  List<Product> orderProducts;
  String tot;
  var isLoading = false;
  _FinalPlaceOrderScreenState({this.deliveryAddress,this.orderProducts,this.tot});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final Order"),
      ),
      body: isLoading?Center(child: Column(children: <Widget>[
        Text("Processing request do not go back..."),
        CircularProgressIndicator()
      ],),):SingleChildScrollView(
              child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
        Text("Delivery To:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
        DisplayAddress(deliveryAddress),
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Text("Review Products",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
        ),
        ...orderProducts.map((product){
          Address shippinAddress = Address();
              shippinAddress.decodeAddress(product.shippingAdress);
          return (Container(
                child: Card(
                        child: Column(
                    children: <Widget>[
                      product.imageUrl.length==0?
            Image.asset("assets/images/noimage.jpg",width: double.infinity,height: 200): 
            CachedNetworkImage(
              width: double.infinity,
              height: 200,
              imageUrl: product.imageUrl,
              placeholder: (context,url)=>CircularProgressIndicator(),),
              Container(
                margin: EdgeInsets.all(10),
                child: Text(product.title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
              Text("Delivery from:"),
              DisplayAddress(shippinAddress)
                    ],
                  ),
                ),
              ));
        }).toList(),
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: orderProducts.length,
        //     itemBuilder: (ctx,i){
              
        //       Address shippinAddress = Address();
        //       shippinAddress.decodeAddress(orderProducts[i].shippingAdress);
        //       return (Container(
        //         child: Card(
        //                 child: Column(
        //             children: <Widget>[
        //               orderProducts[i].imageUrl.length==0?
        //     Image.asset("assets/images/noimage.jpg",width: double.infinity,height: 200): 
        //     CachedNetworkImage(
        //       width: double.infinity,
        //       height: 200,
        //       imageUrl: orderProducts[i].imageUrl,
        //       placeholder: (context,url)=>CircularProgressIndicator(),),
        //       Text(orderProducts[i].title),
        //       Text("Delivery from:"),
        //       DisplayAddress(shippinAddress)
        //             ],
        //           ),
        //         ),
        //       ));
        //     }
        //     ),
        // ),
        RaisedButton(
                textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(color: Colors.green),
                              child: Text("Place order: ₹ "+tot),
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                                await HelperFunctions().purchaseProduct(orderProducts,deliveryAddress);
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: 
                                (ctx){
                                  return MyApp();
                                }
                                ), ModalRoute.withName("/"));
                            },),
              ],
            ),
          ),
      ),
    );
  }
}
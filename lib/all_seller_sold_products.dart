import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './helper/helper_functions.dart';
import './helper/product_model.dart';
class AllSellerSoldProducts extends StatefulWidget {
  @override
  _AllSellerSoldProductsState createState() => _AllSellerSoldProductsState();
}

class _AllSellerSoldProductsState extends State<AllSellerSoldProducts> {
  var isLoading = true;

  List<Product> products;

  @override
  void initState() {
    // TODO: implement initState
    HelperFunctions().fetchAllTransactions().then((prods){
      setState(() {
        isLoading = false;
        products = prods;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = HelperFunctions.width;
    return Scaffold(
      appBar: AppBar(title: Text("Sold Products"),
      actions: <Widget>[
        products==null?
        IconButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            var temp = await HelperFunctions().fetchAllTransactions();
           setState(() {
             isLoading = false;
             products = temp;
           });
          },
          icon: Icon(Icons.refresh),
        ):Text("")
      ],),
      body: isLoading?Center(child: CircularProgressIndicator()):
       RefreshIndicator(
         onRefresh: ()async{
           var temp = await HelperFunctions().fetchAllTransactions();
           setState(() {
             products = temp;
           });
         },
         child: products == null?Center(child: Text("No products Sold"),):
         ListView.builder(
          itemCount: products.length,
          itemBuilder: (ctx, i) {
            return Card(
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
                      Text("₹ "+(products[i].price*products[i].quantity).toString(),softWrap:true,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.green),)
                    ],
                  ),
                )
              ])),
            );
          }),
       )
    );
  }
}
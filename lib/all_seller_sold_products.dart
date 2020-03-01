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
           itemBuilder: (ctx,i){
           return(
             Card(
               child: Container(
                 margin: EdgeInsets.all(10),
                 padding: EdgeInsets.all(10),
                 child: Column(
                   children: <Widget>[
                     Text(products[i].title),
                     Text(products[i].quantity.toString())
                   ],
                 ),
               ),
             )
           );
         }),
       )
    );
  }
}
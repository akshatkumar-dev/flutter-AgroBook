import 'package:flutter/material.dart';
import './helper/helper_functions.dart';
import './helper/product_model.dart';

class AllBuyerTransactions extends StatefulWidget {
  @override
  _AllBuyerTransactionsState createState() => _AllBuyerTransactionsState();
}

class _AllBuyerTransactionsState extends State<AllBuyerTransactions> {
  List<Product> products;
  var isLoading = true;
  @override
  void initState() {
    HelperFunctions().fetchAllBuyerTransactions().then((value) {
      setState(() {
        isLoading = false;
        products = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Transactions"),
          actions: <Widget>[
            products == null
                ? IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      var x =
                          await HelperFunctions().fetchAllBuyerTransactions();
                      setState(() {
                        products = x;
                        isLoading = false;
                      });
                    },
                  )
                : Text("")
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  var x = await HelperFunctions().fetchAllBuyerTransactions();
                  setState(() {
                    products = x;
                    isLoading = false;
                  });
                },
                child: products==null?Center(child: Text("No Products bought"),): ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (ctx, i) {
                      return Card(
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
                      );
                    }),
              ));
  }
}

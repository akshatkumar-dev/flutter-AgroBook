import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './add_product_screen.dart';
import './helper/helper_functions.dart';
import './helper/product_model.dart';
import './update_product_details.dart';
import './all_seller_sold_products.dart';
class MainSellerScreen extends StatefulWidget {
  @override
  _MainSellerScreenState createState() => _MainSellerScreenState();
}

class _MainSellerScreenState extends State<MainSellerScreen> {
  var isLoading = true;
  List<Product> productList;
  var sellerId = HelperFunctions.currentId;
  @override
  void initState() {
      HelperFunctions().fetchAllSellerProducts(sellerId).then((value){
        setState(() {
          productList = value;
          isLoading = false;
        });
      });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
      appBar: AppBar(
        title: Text("Seller Screen"),
        actions: <Widget>[
          Builder(
                      builder: (ctx)=>IconButton(
              icon: Icon(Icons.info),
              onPressed: (){
                Navigator.of(ctx).push(MaterialPageRoute(builder: (ctxx){
                  return AllSellerSoldProducts();
                }));
              },
            ),
          ),
          productList==null?
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: ()async{
              setState(() {
                isLoading = true;
              });
              var value = await HelperFunctions().fetchAllSellerProducts(sellerId);
            setState(() {
              isLoading = false;
              productList = value;
            });
            },
          ):Text("")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_){
            return AddProductScreen();
          }));
        },
      ),
      body: isLoading?
        Center(child: CircularProgressIndicator(),):
        RefreshIndicator(
          onRefresh: () async {
            var value = await HelperFunctions().fetchAllSellerProducts(sellerId);
            setState(() {
              productList = value;
            });
          },
          child: productList==null?
          Center(
              child: Text("No products added"),
            ):
           ListView.builder(
            itemCount: productList.length,
            itemBuilder: (ctx,i){
            return InkWell(
              onTap: (){
                Navigator.of(ctx).push(MaterialPageRoute(builder: (ctxx){
                  return UpdateProductDetails(productList[i]);
                }));
              },
              child: Card(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: productList[i].imageUrl.length==0?
          Image.asset("assets/images/noimage.jpg",fit: BoxFit.cover,): 
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: productList[i].imageUrl,
            placeholder: (context,url)=>CircularProgressIndicator(),
          ),
          title: Text(productList[i].title),
          subtitle: Text(productList[i].stock.toString()),
          trailing: Text(productList[i].price.toString()),
        ),
      ),
    ));
          }),
          
      ),
    ));
    
  }
}
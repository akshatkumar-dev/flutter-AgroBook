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
  TextEditingController quantityController = TextEditingController(text: "1");
  _ProductDetailsScreenState(this.product);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Builder(
                      builder: (ctx)=>IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(ctx).push(MaterialPageRoute(builder: (ctxx){
                  return ViewCartScreen(); 
                }));
              },
            ),
          )
        ],
        title: Text("Details"),
      ),
      body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                child: Column(
          children: <Widget>[
            product.imageUrl.length > 0?
            CachedNetworkImage(
                imageUrl: product.imageUrl,
                placeholder: (ctx,url)=>CircularProgressIndicator(),
            ):
            Image.asset("assets/images/noimage.jpg",
            ),
            Text(product.title),
            Text(product.stock.toString()),
            Text(product.price.toString()),
            Text(product.description),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Quantity"
              ),
              controller: quantityController,
              keyboardType: TextInputType.numberWithOptions(signed: false,decimal: true),
            ),
            Builder(
                          builder:(ctx)=> RaisedButton(
                  child: Text("Add to Cart"),
                  onPressed: () async {
                    setState(() {
                      isUploading = true;
                    });
                    if(double.parse(quantityController.text) <= product.stock && double.parse(quantityController.text) > 0){

                    await HelperFunctions().addItemToCart(product.id,double.parse(quantityController.text));
                    setState(() {
                      isUploading = false;
                    Scaffold.of(ctx).showSnackBar(SnackBar(content: Text("Added to Cart"),));
                    });
                    }
                    else{
                      setState(() {
                        isUploading = false;
                      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text("Quantity greater than Stock"),));
                      });

                    }
                  },
              ),
            ),
            Builder(
                          builder:(ctxx)=> RaisedButton(
                  child: Text("Buy Now"),
                  onPressed: (){
                    if(double.parse(quantityController.text) <= product.stock && double.parse(quantityController.text) > 0){
                      product.setQuantity(double.parse(quantityController.text));
                      Navigator.of(ctxx).push(MaterialPageRoute(builder: (ctx){
                        List<Product> products = List<Product>();
                        products.add(product);
                        return CheckoutScreen(products);
                      }));
                    }
                    else{
                      Scaffold.of(ctxx).showSnackBar(SnackBar(content: Text("Quantity greater than Stock"),));
                    }
                  },
              ),
            ),
            isUploading?CircularProgressIndicator():Text("")
          ],
        ),
              ),
      )
    );
  }
}
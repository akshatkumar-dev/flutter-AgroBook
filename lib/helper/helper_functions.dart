import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';

import './product_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HelperFunctions{
  var _letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-_";
  static var selectedCartItems = List<int>();
  static var currentId;
  DatabaseReference _productsReference = FirebaseDatabase.instance.reference().child("products");
  DatabaseReference _sellerReference = FirebaseDatabase.instance.reference().child("sellers");
  DatabaseReference _buyerReference = FirebaseDatabase.instance.reference().child("buyers");
  DatabaseReference _cartReference = FirebaseDatabase.instance.reference().child("cart");
  StorageReference _productImageReference = FirebaseStorage.instance.ref().child("products");
  DatabaseReference _transactionReference = FirebaseDatabase.instance.reference().child("transactions");

  String _getRandomString(int length,String givenString) {
    var rng = Random();
    var string = "";
    for(int i = 0;i<length;i++){
      string+=givenString[rng.nextInt(64)];
    }
    return string;
  }
  String _generateId(){
    var string1 = _getRandomString(32, _letters);
    var string2 = _getRandomString(32, _letters);
    var string3 = string1+string2;
    var finalString = _getRandomString(32, string3);
    return finalString;
  }
  
  Future<String> setId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var newId = _generateId();
    await prefs.setString("key",newId);
    HelperFunctions.currentId = newId;
    return newId;
  }
  Future<String> getId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("key") ?? null;
    HelperFunctions.currentId = id;
    return id;
  }

  Product _insertData(key,value){
    var x = Product(
        category: value["category"],
         id: key,
         title: value["title"],
        sellerId: value["sellerId"],
        imageUrl: value["imageUrl"],
        price: double.parse(value["price"].toString()),
        stock: double.parse(value["stock"].toString()),
        description: value["description"],
        shippingAdress: value["shippingAdress"]
      );
    return x;
  }
  Future<List<Product>> fetchAllProducts() async {
    DataSnapshot dataSnapshot = await _productsReference.once();
    if(dataSnapshot.value == null) {return null;}
    Map<dynamic,dynamic> mapData = dataSnapshot.value;
     List<Product> allData = List<Product>();
     mapData.forEach((key,value){
      var x = _insertData(key,value);
      allData.add(x);
    });
    return allData;
  }
  Future<List<Product>> fetchAllSellerProducts(String sellerId) async {
    DataSnapshot dataSnapshot = await _productsReference.once();
        if(dataSnapshot.value == null) {return null;}
    Map<dynamic,dynamic> mapData = dataSnapshot.value;
    List<Product> allData = List<Product>();
    mapData.forEach((key,value){
      if(value["sellerId"] == sellerId){
        var x = _insertData(key,value);
        allData.add(x);
      }
    });
    return allData;
  }
  Future<List<Product>> fetchAllCategoryProduct(String category) async{
    DataSnapshot dataSnapshot = await _productsReference.once();
        if(dataSnapshot.value == null) {return null;}

    Map<dynamic,dynamic> mapData = dataSnapshot.value;
    List<Product> allData = List<Product>();
    mapData.forEach((key,value){
      if(value["category"] == category){
        var x = _insertData(key,value);
        allData.add(x);
      }
    });
    return allData;
  }
  Future<void> fetchAllSellers() async{
    DataSnapshot dataSnapshot = await _sellerReference.once();
    print(dataSnapshot.value);
  }
  Future<void> fetchAllBuyers() async{
    DataSnapshot dataSnapshot = await _buyerReference.once();
    print(dataSnapshot.value);
  }
  Future<void> updateProduct(Product product) async{
    await _productsReference.child(product.id).update(<String,Object>{
      "title":product.title,
      "stock":product.stock,
      "price":product.price,
      "imageUrl":product.imageUrl,
      "sellerId":product.sellerId,
      "category": product.category,
      "shippingAdress": product.shippingAdress,
      "description": product.description
    });

  }
  Future<void> uploadProductDetails(Product product) async {
    await _productsReference.push().set(<String,Object>{
      "title":product.title,
      "stock":product.stock,
      "price":product.price,
      "imageUrl":product.imageUrl,
      "sellerId":product.sellerId,
      "category": product.category,
      "shippingAdress": product.shippingAdress,
      "description": product.description
    });
  }
  Future<String> uploadImage(File imageFile,String fileName) async{
    var id = HelperFunctions.currentId;
    var reference = _productImageReference.child(id+"/"+fileName);
    StorageUploadTask storageUploadTask = reference.putFile(imageFile);
    await storageUploadTask.onComplete;
    if(storageUploadTask.isComplete){
      if(storageUploadTask.isSuccessful){
        String downloadLink = await storageUploadTask.lastSnapshot.ref.getDownloadURL();
        return downloadLink;
      }
    }
      return null;
  }

  Future<void> initializeId() async {
    var id = await getId();
    if(id == null){
      id = await setId();
    }
  }

  Future<void> favouriteItem(String productId) async {
    var id = HelperFunctions.currentId;
    var reference = _cartReference.child(id+"/"+productId);
  }
  Future<void> addItemToCart(String productId,double quantity) async {
    var id = HelperFunctions.currentId;
    var reference = _cartReference.child(id+"/"+productId);
    await reference.set(quantity);
  }

  Future<List<Product>> removeItemsFromCart(String productId) async{
    
    var id = HelperFunctions.currentId;
     await _cartReference.child(id+"/"+productId).remove();
     var newProducts = await getAllCartItems();
     return newProducts;
  }

  Future<List<Product>> _getListOfProduct(List<String> productIds) async {
    var allProducts = await fetchAllProducts();
    var cartItems = allProducts.where((product){
      if(productIds.contains(product.id)){return true;}
      return false;
    }).toList();
    return cartItems;
  }
  Future<List<Product>> getAllCartItems() async {
    var id = HelperFunctions.currentId;
    var reference = _cartReference.child(id);
    DataSnapshot dataSnapshot = await reference.once();
    if(dataSnapshot.value == null){return null;}
    Map<dynamic,dynamic> mapData = dataSnapshot.value;
    List<String> productIds = List<String>();
    List<double> productQuantites = List<double>();
    mapData.forEach((key,value){
      productIds.add(key);
      productQuantites.add(double.parse(value.toString()));
    });
    var listOfProducts = await _getListOfProduct(productIds);
    var i = 0;
    List<Product> newList = List<Product>();
    listOfProducts.forEach((value){
      value.setQuantity(productQuantites[i]);
      newList.add(value);
      i++;
    });
    return newList;
  }
  double calculateTotalPrice(List<Product> products){
    double sum = 0;
    if(products == null){return 0.0;}
    products.forEach((value){
      sum+=value.price * value.quantity;
    });
    return sum;
  }

  Future<void> saveAddress(String address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("address",address);
  }

  Future<String> getAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var address = preferences.getString("address") ?? null;
    return address;
  }

  Future<void> saveShippingAddress(String address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("shippingaddress",address);
  }
  Future<String> getShippingAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var address = preferences.getString("shippingaddress") ?? null;
    return address;
  }

  Future<void> purchaseProduct(List<Product> products) async{
    var id = HelperFunctions.currentId;
    var reference = _transactionReference.child(id);
    List<Map<String,String>> toUpload = List<Map<String,String>>();
    products.forEach((product){
      var map = {
        "id":product.id,
        "quantity":product.quantity.toString(),
        "sellerId":product.sellerId
      };
      toUpload.add(map);
    });
    await reference.push().set(toUpload);
  }

  Future<List<Product>> fetchAllTransactions() async {
    var id = HelperFunctions.currentId;
    var datasnapshot = await _transactionReference.once();
    Map<dynamic,dynamic> nextValue = datasnapshot.value;
    List<String> productIds = List<String>();
    List<String> quantity = List<String>();
    nextValue.forEach((key,value){
      Map<dynamic,dynamic> temp = value;
      temp.forEach((tempKey,tempValue){
        tempValue.forEach((f){
          if(f["sellerId"] == id){
            productIds.add(f["id"]);
            quantity.add(f["quantity"]);
          }
        });
      });
    });
    if(productIds.length == 0) {return null;}
    var listOfProducts = await _getListOfProduct(productIds);
    var i = 0;
      List<Product> newList = List<Product>();
      listOfProducts.forEach((value){
      value.setQuantity(double.parse(quantity[i]));
      newList.add(value);
      i++;
    });
    return newList;
  }

  Future<List<Product>> fetchAllBuyerTransactions() async {
    var id = HelperFunctions.currentId;
    var reference = _transactionReference.child(id);
    var datasnapshot = await reference.once();
    Map<dynamic,dynamic> data = datasnapshot.value;
    var productIds = List<String>();
    var quantity = List<String>();
    data.forEach((key,value){
      value.forEach((f){
        productIds.add(f["id"]);
        quantity.add(f["quantity"]);
      });
    });
    if(productIds.length == 0) {return null;}
    var listOfProducts = await _getListOfProduct(productIds);
    var i = 0;
      List<Product> newList = List<Product>();
      listOfProducts.forEach((value){
      value.setQuantity(double.parse(quantity[i]));
      newList.add(value);
      i++;
    });
    return newList;
  }
}
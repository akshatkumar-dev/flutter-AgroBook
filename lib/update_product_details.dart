import 'dart:io';

import 'package:agro_book/helper/product_model.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import './helper/helper_functions.dart';
import './helper/address_model.dart';
class UpdateProductDetails extends StatefulWidget {
  Product prod;
  UpdateProductDetails(this.prod);
  @override
  _UpdateProductDetailsState createState() => _UpdateProductDetailsState(prod);
}

class _UpdateProductDetailsState extends State<UpdateProductDetails> {
  var titleController = TextEditingController();  
  var priceController = TextEditingController();  
  var stockController = TextEditingController();
  var shippingController = TextEditingController();
  var descriptionController = TextEditingController();
  TextEditingController houseNameController = TextEditingController(text: "");
  TextEditingController blockNumberController = TextEditingController(text: "");
  TextEditingController apartmentNumberController = TextEditingController(text: "");
  TextEditingController cityNameController = TextEditingController(text: "");
  TextEditingController pincodeController = TextEditingController(text: "");
  TextEditingController streetNameController = TextEditingController(text: "");
  TextEditingController stateNameController = TextEditingController(text: "");
  TextEditingController localityNameController = TextEditingController(text: "");
  var saveAddress = false;
  var category = "Seeds";
  var isLoading = false;
  var isImageUploaded = false;
  var imageLink = "";
  var isImageUploading = false;
  var isUploaded = false;
  File imageFile;
  Product product;
_UpdateProductDetailsState(this.product);
  @override
  void initState() {
    HelperFunctions().getShippingAddress().then((value){
      if(value != null){
        Address address = Address();
        address.decodeAddress(value);
        setState(() {  
          titleController.text = product.title;  
          priceController.text = product.price.toString();  
          stockController.text = product.stock.toString();
          descriptionController.text = product.description;
        houseNameController.text = address.houseName;
        blockNumberController.text = address.blockNumber;
        apartmentNumberController.text = address.apartmentNumber;
        cityNameController.text = address.cityName;
        pincodeController.text = address.pincode;
        streetNameController.text = address.streetName;
        stateNameController.text = address.stateName;
        localityNameController.text = address.localityName;
        });
      }
      super.initState();
    });
    // TODO: implement initState
  }  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body:  isLoading?Center(child:CircularProgressIndicator()): SingleChildScrollView(
              child: Card(
                              child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: "Item title"),
                        controller: titleController,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10,bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Text("Product Category:   "),
                        DropdownButton(
                          value: category,
                          icon: Icon(Icons.arrow_drop_down),
                          onChanged: (value){
                            setState(() {
                              category = value;
                            });
                          },
                          items: <String>["Seeds","Tools","Fertilizers"].map<DropdownMenuItem<String>>((value){
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                          ],
                        ),
                      ),

                      TextField(
                        decoration: InputDecoration(labelText: "Price (/Kg)"),
                        controller: priceController,
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Available Stock (/Kg)"),
                        controller: stockController,
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Product description"),
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                      ),
                      Text("Enter your delivery address. Please ensure the address is correct else the product cannot be delivered",softWrap: true,),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "House Number / Apartment number"
                        ),
                        controller: apartmentNumberController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Block number"
                        ),
                        controller: blockNumberController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "House Name/ Apartment Name"
                        ),
                        controller: houseNameController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Street Name"
                        ),
                        controller: streetNameController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Locality Name"
                        ),
                        controller: localityNameController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "City Name"
                        ),
                        controller: cityNameController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "State Name"
                        ),
                        controller: stateNameController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Pincode"
                        ),
                        controller: pincodeController,
                        keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                      ),
                      Row(
                        children: <Widget>[
                          Text("Save this Address?"),
                          Checkbox(
                            onChanged:(value){
                              setState(() {
                                saveAddress = value;
                              });
                            },
                            value: saveAddress
                            ,)
                        ],
                      ),
                      
                      isImageUploaded? Container( margin: EdgeInsets.all(10),child: Image.file(imageFile,height: 150,width: 150,)):Text(""),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            RaisedButton(
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(color: Colors.green),
                                child: Text("Upload Product"),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                Address address = Address(
                          apartmentNumber: apartmentNumberController.text,
                          blockNumber: blockNumberController.text,
                          cityName: cityNameController.text,
                          stateName: stateNameController.text,
                          localityName: localityNameController.text,
                          pincode: pincodeController.text,
                          houseName: houseNameController.text,
                          streetName: streetNameController.text
                        );
                      if(saveAddress){
                        var newAddress = address.encodeAddress();
                        await HelperFunctions().saveShippingAddress(newAddress);
                      }
                                var sellerId = HelperFunctions.currentId;
                                var newProduct = Product(
                                  id: product.id,
                                  title: titleController.text,
                                  stock: double.parse(stockController.text),
                                  price: double.parse(priceController.text),
                                  sellerId: sellerId,
                                  imageUrl: imageLink,
                                  category: category,
                                  description: descriptionController.text,
                                  shippingAdress: address.encodeAddress()
                                );
                                await HelperFunctions().updateProduct(newProduct);
                                setState(() {
                                  isLoading = false;
                                  isUploaded = true;
                                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text("Product Uploaded"),));
                                  titleController.text = "";
                                  stockController.text = "";
                                  category = "Seeds";
                                  priceController.text = "";
                                  isImageUploaded = false;
                                  descriptionController.text = "";
                                  shippingController.text = "";
                                    saveAddress=false;
                                });
                              },
                            ),
                            Builder(
                                                        builder:(ctx)=> Container(
                                margin: EdgeInsets.only(left: 10,right: 10),
                                child: OutlineButton(
                                  
                                  textColor: Colors.green,
                                  child: Text("Upload Image"),
                                  onPressed: () async {
                                      setState(() {
                                        isImageUploading = true;
                                      });
                                      String filePath = await FilePicker.getFilePath(type: FileType.IMAGE);
                                      if(filePath != null){
                                      var fileName = filePath.split("/").last;
                                      imageFile = File(filePath);
                                      var downloadLink = await HelperFunctions().uploadImage(imageFile,fileName);
                                      if(downloadLink == null){
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text("Image upload failed try later")
                                        ));
                                      }
                                      else{
                                      setState(() {
                                        isImageUploading = false;
                                        imageLink = downloadLink;
                                        isImageUploaded = true;
                                      });
                                      }
                                      }
                                      else{
                                        setState(() {
                                          isImageUploading = false;
                                        Scaffold.of(ctx).showSnackBar(SnackBar(
                                          content: Text("No file selected")
                                        ));
                                        });
                                      }
                                  },
                                ),
                              ),
                            ),
                            isImageUploading?CircularProgressIndicator():Text("")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      )
    );
  }
}
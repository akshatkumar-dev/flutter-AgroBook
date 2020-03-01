import 'package:agro_book/helper/product_model.dart';
import 'package:flutter/material.dart';
import './helper/address_model.dart';
import './helper/helper_functions.dart';
import './final_place_order_screen.dart';
class CheckoutScreen extends StatefulWidget {
  List<Product> prods;
  CheckoutScreen(this.prods);
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState(prods);
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController houseNameController = TextEditingController(text: "");
  TextEditingController blockNumberController = TextEditingController(text: "");
  TextEditingController apartmentNumberController = TextEditingController(text: "");
  TextEditingController cityNameController = TextEditingController(text: "");
  TextEditingController pincodeController = TextEditingController(text: "");
  TextEditingController streetNameController = TextEditingController(text: "");
  TextEditingController stateNameController = TextEditingController(text: "");
  TextEditingController localityNameController = TextEditingController(text: "");
  var saveAddress = false;
  List<Product> products;
  _CheckoutScreenState(this.products);
  @override
  void initState() {
    // TODO: implement initState
    HelperFunctions().getAddress().then((value){
      if(value != null){
        Address address = Address();
        address.decodeAddress(value);
        setState(() {  
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: SingleChildScrollView(
              child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
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
            RaisedButton(
                    textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(color: Colors.green),
                                  child: Text("Proceed to confirmation"),
                                ),
                    onPressed: ()async{
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
                        await HelperFunctions().saveAddress(newAddress);
                      }
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                        return FinalPlaceOrderScreen(delivery: address,products: products,);
                      }));
                    },
                  )
          ],),
        ),
      ),
    );
  }
}
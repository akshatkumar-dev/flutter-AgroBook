import 'package:agro_book/helper/address_model.dart';
import 'package:flutter/material.dart';
class DisplayAddress extends StatelessWidget {
  Address address;
  DisplayAddress(this.address);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(

        children: <Widget>[
          Container(margin:EdgeInsets.all(10),child: Text("House/Apartment number: "+address.apartmentNumber)),
          Container(margin:EdgeInsets.all(10),child: Text("Block Number: "+address.blockNumber)),
          Container(margin:EdgeInsets.all(10),child: Text("House Name: "+address.houseName)),
          Container(margin:EdgeInsets.all(10),child: Text("Street Name: "+address.streetName)),
          Container(margin:EdgeInsets.all(10),child: Text("Locality Name: "+address.localityName)),
          Container(margin:EdgeInsets.all(10),child: Text("City Name:"+address.cityName)),
          Container(margin:EdgeInsets.all(10),child: Text("State Name: "+address.stateName)),
          Container(margin:EdgeInsets.all(10),child: Text("Pincode: "+address.pincode))
        ],
      ),
    );
  }
}
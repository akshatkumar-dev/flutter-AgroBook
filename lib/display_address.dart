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
          Text("House/Apartment number: "+address.apartmentNumber),
          Text("Block Number: "+address.blockNumber),
          Text("House Name: "+address.houseName),
          Text("Street Name: "+address.streetName),
          Text("Locality Name: "+address.localityName),
          Text("City Name:"+address.cityName),
          Text("State Name: "+address.stateName),
          Text("Pincode: "+address.pincode)
        ],
      ),
    );
  }
}
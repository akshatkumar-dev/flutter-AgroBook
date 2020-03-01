class Address{
  String houseName;
  String blockNumber;
  String apartmentNumber;
  String cityName;
  String pincode;
  String streetName;
  String stateName;
  String localityName;

  Address({
  this.houseName,
  this.blockNumber,
  this.apartmentNumber,
  this.cityName,
  this.pincode,
  this.streetName,
  this.stateName,
  this.localityName
  });
  String encodeAddress(){
    return(
      this.apartmentNumber+"%"+
      this.blockNumber+"%"+
      this.houseName+"%"+
      this.streetName+"%"+
      this.localityName+"%"+
      this.cityName+"%"+
      this.stateName+"%"+
      this.pincode
    );
  }
  void decodeAddress(String toDecode){
    var list = toDecode.split("%");
      this.apartmentNumber=list[0];
      this.blockNumber=list[1];
      this.houseName=list[2];
      this.streetName=list[3];
      this.localityName=list[4];
      this.cityName=list[5];
      this.stateName=list[6];
      this.pincode=list[7];
  }
}
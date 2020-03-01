class Product{
  String id;
  String title;
  double stock;
  double price;
  String sellerId;
  String imageUrl;
  String category;
  String description;
  String shippingAdress;
  String cartId;
  String favouriteId;
  double quantity;
  Product({
    this.id="default",
    this.title="default",
    this.stock=0.0,
    this.price=0.0,
    this.sellerId="default",
    this.imageUrl="",
    this.category="default",
    this.description="default",
    this.shippingAdress="default"});
  void setQuantity(double quantity){
    this.quantity = quantity;
  }
}


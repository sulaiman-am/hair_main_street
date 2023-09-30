class ProductModel {
  dynamic productID;
  dynamic vendorID;
  int? price;
  String? productName;
  String? productDescription;
  String? productImage;
  bool? hasOption;
  int? quantity;

  ProductModel({
    this.quantity,
    this.productID,
    this.vendorID,
    this.hasOption,
    this.price,
    this.productDescription,
    this.productImage,
    this.productName,
  });
}

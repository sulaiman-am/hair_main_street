import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Product productFromdata(String str) => Product.fromdata(json.decode(str));

String productTodata(Product data) => json.encode(data.todata());

class Product {
  dynamic productID;
  bool? allowInstallment;
  Timestamp? createdAt;
  String? description;
  String? category;
  bool? isDeleted;
  bool? isAvailable;
  bool? hasOption;
  List<dynamic>? image;
  String? name;
  int? price;
  int? quantity;
  Timestamp? updatedAt;
  dynamic vendorId;

  Product({
    this.productID,
    this.allowInstallment,
    this.createdAt,
    this.description,
    this.hasOption,
    this.category,
    this.image,
    this.name,
    this.isAvailable,
    this.isDeleted,
    this.price,
    this.quantity,
    this.updatedAt,
    this.vendorId,
  });

  factory Product.fromdata(Map<String, dynamic> data) {
    final List<dynamic>? images = data["image"];
    return Product(
      productID: data["productID"],
      allowInstallment: data["allowInstallment"],
      category: data["category"],
      createdAt: data["createdAt"],
      description: data["description"],
      hasOption: data["hasOption"],
      image: images != null ? List<dynamic>.from(images.map((x) => x)) : [],
      name: data["name"],
      isAvailable: data["isAvailable"],
      isDeleted: data["isDeleted"],
      price: data["price"],
      quantity: data["quantity"],
      updatedAt: data["updatedAt"],
      vendorId: data["vendorID"],
    );
  }

  Map<String, dynamic> todata() => {
        "allowInstallment": allowInstallment,
        "createdAt": createdAt,
        "description": description,
        "category": category,
        "hasOption": hasOption,
        "image": List<dynamic>.from(image!.map((x) => x)),
        "name": name,
        "price": price,
        "isDeleted": isDeleted,
        "isAvailable": isAvailable,
        "quantity": quantity,
        "updatedAt": updatedAt,
        "vendorID": vendorId,
      };
}

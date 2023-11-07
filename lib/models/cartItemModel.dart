import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  dynamic cartItemID;
  dynamic productID;
  int? quantity;
  num? price;
  Timestamp? createdAt;

  CartItem(
      {this.productID,
      this.price,
      this.quantity,
      this.cartItemID,
      this.createdAt});
}

class WishlistItem {
  dynamic productID;
  dynamic wishListItemID;
  Timestamp? createdAt;

  WishlistItem({this.productID, this.wishListItemID, this.createdAt});
}

CheckoutItem checkoutItemFromJson(String str) =>
    CheckoutItem.fromJson(json.decode(str));

String checkoutItemToJson(CheckoutItem data) => json.encode(data.toJson());

class CheckoutItem {
  String? productId;
  String? checkoutitemID;
  String? price;
  String? quantity;
  String? address;
  String? fullName;
  String? phoneNumber;
  String? createdAt;

  CheckoutItem({
    this.productId,
    this.price,
    this.quantity,
    this.createdAt,
    this.checkoutitemID,
    this.address,
    this.fullName,
    this.phoneNumber,
  });

  factory CheckoutItem.fromJson(Map<String, dynamic> json) => CheckoutItem(
      productId: json["productID"],
      price: json["price"],
      quantity: json["quantity"],
      createdAt: json["created at"],
      checkoutitemID: json['checkoutitemID']);

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "price": price,
        "quantity": quantity,
        "created at": createdAt,
        "checkoutitemID": checkoutitemID
      };
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  String? orderId;
  num? paymentPrice;
  String? buyerId;
  String? vendorId;
  num? totalPrice;
  String? shippingAddress;
  int? installmentNumber;
  int? installmentPaid;
  String? orderStatus;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? paymentMethod;
  String? paymentStatus;
  List<String?>? transactionID;

  Orders({
    this.orderId,
    this.paymentPrice,
    this.buyerId,
    this.vendorId,
    this.totalPrice,
    this.shippingAddress,
    this.installmentNumber,
    this.installmentPaid,
    this.orderStatus,
    this.createdAt,
    this.updatedAt,
    this.paymentMethod,
    this.paymentStatus,
    this.transactionID,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      orderId: json['orderID'],
      paymentPrice: json['payment price'],
      buyerId: json['buyerID'],
      vendorId: json['vendorID'],
      totalPrice: json['totalPrice'],
      shippingAddress: json['shipping address'],
      installmentNumber: json['installment number'],
      installmentPaid: json['installment paid'],
      orderStatus: json['order status'],
      createdAt: json['created at'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['created at'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(json['updated at'])
          : null,
      paymentMethod: json['payment method'],
      paymentStatus: json['payment status'],
      transactionID: json['transactionID'] != null
          ? List<String?>.from(json['transactionID'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderId,
      'payment price': paymentPrice,
      'buyerID': buyerId,
      'vendorID': vendorId,
      'totalPrice': totalPrice,
      'shipping address': shippingAddress,
      'installment number': installmentNumber,
      'installment paid': installmentPaid,
      'order status': orderStatus,
      'created at': createdAt?.millisecondsSinceEpoch,
      'updated at': updatedAt?.millisecondsSinceEpoch,
      'payment method': paymentMethod,
      'payment status': paymentStatus,
      'transactionID': transactionID,
    };
  }
}

OrderItem orderItemFromJson(String str) => OrderItem.fromJson(json.decode(str));

String orderItemToJson(OrderItem data) => json.encode(data.toJson());

class OrderItem {
  String? productId;
  String? quantity;
  String? price;

  OrderItem({
    this.productId,
    this.quantity,
    this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json["productID"],
        quantity: json["quantity"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "quantity": quantity,
        "price": price,
      };
}

DatabaseOrderResponse databaseOrderResponseFromJson(String str) =>
    DatabaseOrderResponse.fromJson(json.decode(str));

String databaseOrderResposeToJson(OrderItem data) => json.encode(data.toJson());

class DatabaseOrderResponse {
  String? orderId;
  num? paymentPrice;
  String? buyerId;
  String? vendorId;
  num? totalPrice;
  String? shippingAddress;
  int? installmentNumber;
  int? installmentPaid;
  String? orderStatus;
  dynamic createdAt;
  dynamic updatedAt;
  String? paymentMethod;
  String? paymentStatus;
  List<String?>? transactionID;
  List<OrderItem>? orderItem;

  DatabaseOrderResponse(
      {this.buyerId,
      this.createdAt,
      this.installmentNumber,
      this.installmentPaid,
      this.orderId,
      this.orderStatus,
      this.paymentMethod,
      this.paymentPrice,
      this.paymentStatus,
      this.orderItem,
      this.shippingAddress,
      this.transactionID,
      this.totalPrice,
      this.updatedAt,
      this.vendorId});

  factory DatabaseOrderResponse.fromJson(Map<String, dynamic> json) =>
      DatabaseOrderResponse(
        orderId: json["orderID"],
        buyerId: json["buyerID"],
        vendorId: json["vendorID"],
        totalPrice: json["totalPrice"],
        shippingAddress: json["shipping address"],
        orderStatus: json["order status"],
        createdAt: json["created at"],
        updatedAt: json["updated at"],
        installmentNumber: json["installment number"],
        installmentPaid: json["installment paid"],
        paymentMethod: json['payment method'],
        paymentStatus: json['payment status'],
        transactionID: json['transactionID'] != null
            ? List<String?>.from(json['transactionID'])
            : null,
        paymentPrice: json['payment price'],
        orderItem: List<OrderItem>.from(json["orderItems"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "payment price": paymentPrice,
        "buyerID": buyerId,
        "vendorID": vendorId,
        "totalPrice": totalPrice,
        "shipping address": shippingAddress,
        "order status": orderStatus,
        "created at": createdAt,
        "updated at": updatedAt,
        "transactionID": transactionID,
        "payment method": paymentMethod,
        "payment status": paymentStatus,
        "installment number": installmentNumber,
        "installment paid": installmentPaid,
        "order item": orderItem,
      };
}

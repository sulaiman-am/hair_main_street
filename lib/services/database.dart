import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/models/notificationsModel.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/models/wallet_transaction.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  User? currentUser = FirebaseAuth.instance.currentUser;

  var auth = FirebaseAuth.instance;

  var fcm = FirebaseMessaging.instance;

  CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection("userProfile");

  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  CollectionReference vendorsCollection =
      FirebaseFirestore.instance.collection('vendors');

  CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat');

  CollectionReference walletCollection =
      FirebaseFirestore.instance.collection('wallet');

  CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  //get the role dynamically
  Stream<DocumentSnapshot> get getRoleDynamically {
    return userProfileCollection.doc(currentUser!.uid).snapshots();
  }

  //verify role
  Future<Map<String, dynamic>?> verifyRole() async {
    try {
      DocumentSnapshot documentSnapshot =
          await userProfileCollection.doc(currentUser!.uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? user =
            documentSnapshot.data() as Map<String, dynamic>;
        //print(user);
        if (user["isVendor"] == true) {
          return {"Vendor": currentUser!.uid};
        } else if (user["isBuyer"] == true) {
          return {"Buyer": currentUser!.uid};
        } else if (user['isAdmin'] == true) {
          return {'Admin': currentUser!.uid};
        } else {
          throw Exception();
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //create user profile and update profile
  Future createUserProfile() async {
    try {
      //create wishlist subcollection
      userProfileCollection.doc(uid).collection('wishlist');

      //create a cart subcollection
      userProfileCollection.doc(uid).collection('cart');

      // make the user profile
      return await userProfileCollection.doc(uid).set({
        "email": currentUser!.email,
        "uid": uid,
        'fullname': "",
        'phonenumber': "",
        'address': "",
        'isVendor': false,
        'isBuyer': true,
        'isAdmin': false,
      });
    } catch (e) {
      return (e);
    }
  }

  Future updateUserProfile(String fieldName, value) async {
    try {
      await userProfileCollection
          .doc(currentUser!.uid)
          .update({fieldName: value});

      var result = await userProfileCollection.doc(currentUser!.uid).get();
      //result.data() as Map<String, dynamic>;
      var user = result.data() as Map<String, dynamic>;
      return {
        "fullname": user['fullname'],
        "address": user['address'],
        "phoneNumber": user['phonenumber']
      };
    } catch (e) {
      print(e);
    }
  }

  Future<MyUser?> getBuyerDetails(String userID) async {
    try {
      var result = await userProfileCollection.doc(userID).get();
      if (result.exists) {
        var user = MyUser.fromJson(result.data() as Map<String, dynamic>);
        return user;
      } else {
        print("Buyer does not exist");
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return null;
  }

  //vendor stuff including vendor profile
  Future createVendor(Vendors vendor) async {
    try {
      var documentID = currentUser!.uid;
      await vendorsCollection.doc(documentID).set({
        "docID": documentID,
        "userID": currentUser!.uid,
        "shop name": vendor.shopName,
        "account info": vendor.accountInfo,
        "contact info": vendor.contactInfo,
        "first verification": vendor.firstVerification,
        "second verification": vendor.secondVerification,
        "createdAt": FieldValue.serverTimestamp(),
      });
      vendorsCollection.doc(documentID).collection("withdrawal requests");
      return "success";
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  //getVendors
  Stream<List<Vendors>> getVendors() {
    var response = vendorsCollection.snapshots();
    return response.map((event) => event.docs
        .map((doc) => Vendors.fromdata(doc.data() as Map<String, dynamic>))
        .toList());
  }

  //get vendor details
  Stream<Vendors?> getVendorDetails() {
    try {
      if (currentUser == null) {
        return Stream.error("Current user is null");
      }

      var response = vendorsCollection
          .where('userID', isEqualTo: currentUser!.uid)
          .snapshots();

      return response.map((event) {
        if (event.docs.isNotEmpty) {
          var data = event.docs.first.data() as Map<String, dynamic>;
          return Vendors.fromdata(data);
        } else {
          return null;
        }
      });
    } catch (e) {
      print("Error in getVendorDetails: $e");
      return Stream.error(e);
    }
  }

  //approve vendor, an admin function
  Future approveVendor(String vendorID) async {
    try {
      var role = await verifyRole();
      if (role!.keys.contains('Admin')) {
        await vendorsCollection.doc(vendorID).update({"isVerified": true});
        await userProfileCollection.doc(vendorID).update({"isVendor": true});
        return 'success';
      } else {
        return 'Not Authorized';
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  //fetch cart products
  Stream<List<CartItem>> fetchCartItems() async* {
    try {
      var role = await verifyRole();
      // Check if the user has the "Buyer" role
      if (role != null && role.keys.contains("Buyer") ||
          role!.keys.contains("Vendor")) {
        var result = userProfileCollection
            .doc(role["Buyer"])
            .collection("cart")
            .snapshots();

        // Yield the mapped data as a stream
        await for (var event in result) {
          if (event.docs.isEmpty) {
            yield <CartItem>[];
          } else {
            yield event.docs.map((data) {
              var doc = data.data();
              return CartItem(
                cartItemID: doc['cartItemID'],
                price: doc["price"],
                quantity: doc['quantity'],
                productID: doc['productID'],
              );
            }).toList();
          }
        }
      } else {
        print("stuff");
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  //helper function to check if a cart item exists
  Future<Map<dynamic, bool>?> itemExists(
      dynamic productID, userID, String pathName) async {
    final querySnapshot = await userProfileCollection
        .doc(userID)
        .collection(pathName)
        .where('productID', isEqualTo: productID)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    } else if (querySnapshot.docs.first.exists) {
      //print("pow");
      return {querySnapshot.docs.first.id: true};
    }
    return null;
    //return {querySnapshot.docs.firstOrNull!.id: querySnapshot.docs.isNotEmpty};
  }

  //add to cart function
  Future addToCart(CartItem cartItem) async {
    try {
      var role = await verifyRole();
      if (role!.keys.contains("Buyer") || role!.keys.contains("Vendor")) {
        //check if item already exists then add to quantity and calculate price
        var item = await itemExists(cartItem.productID, role["Buyer"], 'cart');
        if (item != null) {
          var quantityIncrement = FieldValue.increment(cartItem.quantity!);
          await userProfileCollection
              .doc(role["Buyer"])
              .collection('cart')
              .doc(item.keys.single)
              .update({
            "quantity": quantityIncrement,
          });
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            // Get the document
            DocumentSnapshot snapshot = await transaction.get(
                userProfileCollection
                    .doc(role["Buyer"])
                    .collection('cart')
                    .doc(item.keys.single));

            // Calculate the new price
            //print(snapshot.get('quantity'));
            num newPrice = (cartItem.price! / cartItem.quantity!) *
                (snapshot.get('quantity'));

            // Update the quantity and price in the transaction
            transaction.update(
                userProfileCollection
                    .doc(role["Buyer"])
                    .collection('cart')
                    .doc(item.keys.single),
                {
                  //"quantity": FieldValue.increment(cartItem.quantity!),
                  "price": newPrice
                });
          });

          // print("done");
        } else {
          //else just add product to cart
          //get cart reference and id
          var cartRef =
              userProfileCollection.doc(role['Buyer']).collection('cart').doc();
          var cartItemId = cartRef.id;
          await userProfileCollection
              .doc(role["Buyer"])
              .collection('cart')
              .doc(cartItemId)
              .set({
            "productID": cartItem.productID,
            "quantity": cartItem.quantity,
            "price": cartItem.price,
            "cartItemID": cartItemId,
          });
        }
        return "Success";
      } else {
        print("Not Authorized");
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  // remove from cart
  Future removeFromCart(dynamic cartItemID) async {
    try {
      final role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        return await productsCollection
            .doc(role['Buyer'])
            .collection('cart')
            .doc(cartItemID)
            .delete();
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  //create order and update orders and get orders

  //get buyers orders
  Stream<List<DatabaseOrderResponse>> getBuyerOrders(String? userID) async* {
    await for (var event in ordersCollection
        .where('buyerID', isEqualTo: userID)
        .orderBy('created at', descending: true)
        .snapshots()) {
      if (event.docs.isEmpty) {
        yield [];
      } else {
        var futures = event.docs.map((doc) async {
          var data = doc.data() as Map<String, dynamic>;
          var orderItemSnapshot =
              await doc.reference.collection('order items').get();
          var orderItems = orderItemSnapshot.docs.map((orderItemDoc) {
            var orderItemData = orderItemDoc.data();
            return OrderItem.fromJson(orderItemData);
          }).toList();
          data["orderItems"] = orderItems;
          //print(data['orderItems']);
          return DatabaseOrderResponse.fromJson(data);
        }).toList();

        var results = await Future.wait(futures);
        yield results;
      }
    }
  }

  //get vendors orders
  Stream<List<DatabaseOrderResponse>> getVendorsOrders(String? userID) async* {
    await for (var event in ordersCollection
        .where('vendorID', isEqualTo: userID)
        .orderBy('created at', descending: true)
        .snapshots()) {
      if (event.docs.isEmpty) {
        yield [];
      } else {
        var futures = event.docs.map((doc) async {
          var data = doc.data() as Map<String, dynamic>;
          var orderItemSnapshot =
              await doc.reference.collection('order items').get();
          var orderItems = orderItemSnapshot.docs.map((orderItemDoc) {
            var orderItemData = orderItemDoc.data();
            return OrderItem.fromJson(orderItemData);
          }).toList();
          data["orderItems"] = orderItems;
          // print(data['orderItems']);
          return DatabaseOrderResponse.fromJson(data);
        }).toList();

        var results = await Future.wait(futures);
        //print(results);
        yield results;
      }
    }
  }

  //create order
  Future createOrder(Orders order, OrderItem orderItem) async {
    try {
      var role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        var orderRef = ordersCollection.doc();
        var orderID = orderRef.id;

        //create order item subcollection
        ordersCollection.doc(orderID).collection('order items');

        //get vendor id from product id provided
        // var result = await productsCollection.doc(orderItem.productId).get();
        // var product = Product.fromdata(result.data() as Map<String, dynamic>);
        // var vendorID = product.vendorId;

        await ordersCollection.doc(orderID).set({
          "payment price": order.paymentPrice,
          "installment number": order.installmentNumber,
          "installment paid": order.installmentPaid,
          "orderID": orderID,
          "buyerID": order.buyerId,
          "vendorID": order.vendorId,
          "totalPrice": order.totalPrice,
          "shipping address": order.shippingAddress,
          "order status": order.orderStatus,
          "created at": FieldValue.serverTimestamp(),
          "updated at": FieldValue.serverTimestamp(),
          "payment method": order.paymentMethod,
          "payment status": order.paymentStatus,
        });

        await ordersCollection
            .doc(orderID)
            .collection('order items')
            .doc(orderID)
            .set({
          "productID": orderItem.productId,
          "quantity": orderItem.quantity,
          "price": orderItem.price,
        });

        return {'Order Created': orderID};
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

//update orderStatus for vendors
  Future updateOrderStatus(String orderID, String orderStatus) async {
    try {
      var role = await verifyRole();
      if (role!.keys.contains("Vendor")) {
        await ordersCollection.doc(orderID).update({
          "order status": orderStatus,
          "updated at": FieldValue.serverTimestamp(),
        });
        return "success";
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  //update order
  Future updateOrder(Orders? order) async {
    try {
      var role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        var updatedFields = {
          "shipping address": order!.shippingAddress,
          "order status": order.orderStatus,
          "updated at": FieldValue.serverTimestamp(),
          "payment method": order.paymentMethod,
          "payment status": order.paymentStatus,
        };
        await ordersCollection.doc(order.orderId).update(updatedFields);
        return "success";
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //get single order
  Future getSingleOrder(String orderID) async {
    try {
      var orderResult = await ordersCollection.doc(orderID).get();
      var orderItem = await ordersCollection
          .doc(orderID)
          .collection("order items")
          .doc(orderID)
          .get();
      var orderResultData = orderResult.data() as Map<String, dynamic>;
      var orderItemData =
          OrderItem.fromJson(orderItem.data() as Map<String, dynamic>);
      orderResultData["orderItems"] = [orderItemData];
      // print("result: ${orderResultData}");
      // print("orderItem: ${orderItemData.productId}");
      return DatabaseOrderResponse.fromJson(orderResultData);
    } catch (e) {
      print(e);
    }
  }

  //image upload for products
  Future<List<dynamic>?> uploadProductImage() async {
    try {
      //actual image
      List<dynamic> productImageList = [];
      dynamic productImage;
      var appDirectoryPath = await getApplicationDocumentsDirectory();

      //pickFile
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ["png", "jpg", "jpeg"],
      );
      if (result != null) {
        print("result ${result.paths}");
        for (var image in result.files) {
          var targetPath =
              "${appDirectoryPath.path}/compressed_image[[${Random().nextInt(1000) + 1}].jpg";
          print("targetPath: $targetPath");
          print("image ${image.path}");
          //compress image
          final compressedImage = await FlutterImageCompress.compressAndGetFile(
            image.path!,
            targetPath,
            quality: 85,
            format: CompressFormat.jpeg,
          );

          //convert to file
          final finalImage = File(compressedImage!.path);
          //firebase Storage reference
          final storageReference = FirebaseStorage.instance.ref("productImage");
          //product images reference
          final productImageReference = storageReference
              .child(currentUser!.uid)
              .child("compress_image[${Random().nextInt(1000) + 1}].jpg");
          //final metadata = await productImageReference.getMetadata();

          productImage = await productImageReference.putFile(finalImage);

          //make sure picture does not already exist
          if (productImageList.contains(productImage)) {
            print("Image Already Added");
          }
          productImageList.add(productImage);
        }
        return productImageList;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //create product
  Future addProduct({Product? product}) async {
    try {
      //ensure only user with appropriate role can add product
      //get the current user role
      var role = await verifyRole();
      if (role!.keys.contains("Vendor")) {
        //create doc reference
        var productRef = productsCollection.doc();
        String productID = productRef.id;
        //print(productID);

        //create a reviews subcollection
        productsCollection
            .doc(productID)
            .collection('reviews')
            .doc(productID)
            .set({});

        //create the actual product
        await productsCollection.doc(productID).set({
          "productID": productID,
          "name": product!.name,
          "price": product.price,
          "image": product.image,
          "hasOption": product.hasOption,
          "allowInstallment": product.allowInstallment,
          "quantity": product.quantity,
          "description": product.description,
          "vendorID": role["Vendor"],
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        });
        return "success";
      } else {
        print("Not Authorized");
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  //update product
  Future updateProduct({Product? product}) async {
    try {
      //ensure only user with appropriate role can add product
      //get the current user role
      var role = await verifyRole();
      if (role!.keys.contains("Vendor")) {
        if (role["Vendor"] == product!.vendorId) {
          var updatedFields = {
            "productID": product!.productID,
            "name": product.name,
            "price": product.price,
            "image": product.image,
            "hasOption": product.hasOption,
            "allowInstallment": product.allowInstallment,
            "quantity": product.quantity,
            "description": product.description,
            "updatedAt": FieldValue.serverTimestamp(),
          };
          await productsCollection.doc(product.productID).update(updatedFields);
          return 'success';
        } else {
          print('not your product');
        }
      } else {
        print("Not Authorized");
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  //delete product
  Future deleteProduct(Product product) async {
    try {
      var role = await verifyRole();
      if (role!.keys.contains("Vendor") && role["Vendor"] == product.vendorId) {
        await productsCollection.doc(product.productID).delete();
        return 'success';
      } else {
        print('not authorized');
        return 'not authorized';
      }
    } on FirebaseException catch (e) {
      print("${e.message} ${e.code}");
    }
  }

  //convert to product
  List<Product?> convertToProduct(QuerySnapshot<Object?> products) {
    if (products.docs.isEmpty) {}
    return products.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Product.fromdata(data);
    }).toList();
  }

  //fetch products
  Stream<List<Product?>> fetchProducts() {
    var stuff = productsCollection.snapshots();
    //print(stuff);
    return stuff.map(
      (event) => convertToProduct(event),
    );
  }

  //fetch single product
  Future fetchSingleProduct(dynamic id) async {
    DocumentSnapshot snapshot = await productsCollection.doc(id).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      Product product = Product.fromdata(data);
      return product;
    }
  }

  // get a vendor's products
  Stream<List<Product>> getVendorProducts(String vendorID) async* {
    try {
      var role = await verifyRole();
      if (role!.keys.contains('Vendor')) {
        // get products based on vendorID
        var response = productsCollection
            .where('vendorID', isEqualTo: vendorID)
            .orderBy('createdAt')
            .snapshots();

        // get every product
        await for (var event in response) {
          if (event.docs.isEmpty) {
            yield <Product>[]; // yield an empty list if there are no products
          } else {
            yield event.docs.map((data) {
              var doc = data.data() as Map<String, dynamic>;
              //print(Product.fromdata(doc));
              return Product.fromdata(doc);
            }).toList();
          }
        }
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: $e');
      // Handle FirebaseException
    } catch (e) {
      print('Exception: $e');
      // Handle other exceptions
    }
  }

  //create or update a vendor
  Future createOrUpdateVendor(Vendors vendor) async {
    try {
      var role = await verifyRole();
      if (role!.keys.contains("Vendor")) {
        if (vendor.docID == null) {
          var docID = vendorsCollection.doc().id;
          Map<String, dynamic> fields = vendor.todata(docID: docID);
          await vendorsCollection.doc(docID).set(fields);
        } else {
          Map<String, dynamic> updateFields = vendor.todata();
          await vendorsCollection.doc(vendor.docID).update(updateFields);
        }
        return 'success';
      }
      return 'not authorized';
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //get ,add, edit and delete reviews
  Stream<List<Review?>> getReviews(String productID) {
    try {
      return productsCollection
          .doc(productID)
          .collection("reviews")
          .snapshots()
          .map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return <Review>[];
        }
        return querySnapshot.docs.map((data) {
          var doc = data.data();
          return Review(
            reviewID: doc['reviewID'],
            user: doc['user'],
            createdAt: doc['createdAt'],
            comment: doc['comment'],
            stars: doc['stars'],
          );
        }).toList();
      });
    } on FirebaseException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
  }

  Future addAReview(Review review, String productID) async {
    try {
      review.user = currentUser!.uid;
      review.createdAt = FieldValue.serverTimestamp() as Timestamp;
      final role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        //create review ref and get its id before creating the review
        var reviewRef =
            productsCollection.doc(productID).collection('review').doc();
        var reviewID = reviewRef.id;
        await productsCollection
            .doc(productID)
            .collection('reviews')
            .doc(reviewID)
            .set({
          "user": currentUser!.uid,
          "createdAt": FieldValue.serverTimestamp(),
          "comment": review.comment,
          "stars": review.stars,
          "reviewID": review.reviewID,
        });
        return "success";
      } else {
        return "Not Authorized";
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  Future deleteReview(String productID, dynamic reviewID) async {
    try {
      final role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        return await productsCollection
            .doc(productID)
            .collection('reviews')
            .doc(reviewID)
            .delete();
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  //payment stuff

  //referral

  //chats
  //start chat
  Future startChat(Chat chat, ChatMessages chatMessage) async {
    try {
      //first check if the chat record exists
      Future<Map<String, bool>> chatExists() async {
        var data = await chatCollection
            .where(
              Filter.or(
                Filter("member1", isEqualTo: chat.member1),
                Filter("member2", isEqualTo: chat.member2),
                Filter("member1", isEqualTo: chat.member2),
                Filter("member2", isEqualTo: chat.member1),
              ),
            )
            .get();
        if (data.docs.isNotEmpty) {
          var result = data.docs.first.data() as Map<String, dynamic>;
          var existingChatID = result["chatID"];
          print(existingChatID);
          return {existingChatID: true};
        } else {
          return {"": false};
        }
      }

      var check = await chatExists();
      var fields = {
        "content": chatMessage.content,
        "id To": chatMessage.idTo,
        "id From": chatMessage.idFrom,
        "timestamp": FieldValue.serverTimestamp(),
      };
      if (check.values.contains(false)) {
        var chatID = chatCollection.doc().id;

        //create chat record first
        var chatFields = {
          "chatID": chatID,
          "member1": chat.member1,
          "member2": chat.member2,
          "recent message sent at": chat.recentMessageSentAt,
          "recent message sent by": chat.recentMessageSentBy,
          "recent message text": chat.recentMessageText,
          "read by": chat.readBy,
        };

        await chatCollection.doc(chatID).set(chatFields);
        //create message subcollection
        return await chatCollection
            .doc(chatID)
            .collection('messages')
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set(fields);
      } else {
        return await chatCollection
            .doc(check.keys.first)
            .collection('messages')
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set(fields);
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //get chats
  Stream<List<ChatMessages?>?> getChats(String member1, String member2) async* {
    Future<Map<String, bool>> chatExists() async {
      var data = await chatCollection
          .where(
            Filter.or(
              Filter("member1", isEqualTo: member1),
              Filter("member2", isEqualTo: member2),
              Filter("member1", isEqualTo: member2),
              Filter("member2", isEqualTo: member1),
            ),
          )
          .get();
      if (data.docs.isNotEmpty) {
        var result = data.docs.first.data() as Map<String, dynamic>;
        var existingChatID = result["chatID"];
        print(existingChatID);
        return {existingChatID: true};
      } else {
        return {"": false};
      }
    }

    var check = await chatExists();
    if (check.values.contains(true)) {
      var result = chatCollection
          .doc(check.keys.first)
          .collection('messages')
          .snapshots();
      await for (var event in result) {
        yield event.docs.map((e) => ChatMessages.fromJson(e.data())).toList();
      }
    } else {
      // Instead of yielding null, yield an empty list
      yield [];
    }
  }

  // add and remove from wishlist and get wishList

  Stream<List<WishlistItem>> fetchWishListItems() async* {
    try {
      var role = await verifyRole();
      // Check if the user has the "Buyer" role
      if (role != null && role.keys.contains("Buyer") ||
          role!.keys.contains("Vendor")) {
        var result = userProfileCollection
            .doc(role["Buyer"])
            .collection("wishlist")
            .snapshots();

        // Yield the mapped data as a stream
        await for (var event in result) {
          if (event.docs.isEmpty) {
            yield <WishlistItem>[];
          } else {
            yield event.docs.map((data) {
              var doc = data.data();
              return WishlistItem(
                createdAt: doc['createdAt'],
                wishListItemID: doc['wishListItemID'],
                productID: doc['productID'],
              );
            }).toList();
          }
        }
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<String?> addToWishList(WishlistItem wishlistItem) async {
    try {
      var role = await verifyRole();
      if (role != null && role.keys.contains('Buyer')) {
        var item =
            await itemExists(wishlistItem.productID, role["Buyer"], 'wishlist');
        if (item != null) {
          return 'exists';
        } else {
          var documentRef = userProfileCollection
              .doc(currentUser!.uid)
              .collection('wishlist')
              .doc();
          var id = documentRef.id;
          await documentRef.set({
            "wishListItemID": id,
            "productID": wishlistItem.productID,
            "createdAt": FieldValue.serverTimestamp(),
          });
          return 'new';
        }
      } else {
        return "not authorized"; // Or a specific value to indicate that the user doesn't have 'Buyer' role.
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
      rethrow; // Re-throw the exception to inform the caller about the error.
    }
  }

  Future removeFromWishList(dynamic wishListItemID) async {
    try {
      final role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        return await productsCollection
            .doc(role['Buyer'])
            .collection('cart')
            .doc(wishListItemID)
            .delete();
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  //become a seller
  Future becomeASeller(Vendors vendor) async {
    try {
      var result = await userProfileCollection.doc(vendor.userID).get();
      if (result.exists) {
        //create a vendor collection for them
        var docID = vendorsCollection.doc().id;
        Map<String, dynamic> fields = vendor.todata(docID: docID);
        await vendorsCollection.doc(docID).set(fields);

        // update their isVendor tag
        var data = result.data() as Map<String, dynamic>;
        if (data['isVendor'] == false) {
          await userProfileCollection
              .doc(currentUser!.uid)
              .update({"isVendor": true});
        }
        return 'success';
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //check if wallet exists
  Future<String?> checkIfWalletExists(String userID) async {
    var response = await walletCollection.doc(userID).get();
    if (response.exists) {
      return "exists";
    }
    return null;
  }

  //handle things wallet i.e create and update wallet and transactions
  void updateWalletAfterOrderPlacement(
      String userID, int amount, String description, String type) async {
    // Retrieve the user's wallet document reference
    DocumentReference walletRef = walletCollection.doc(userID);

    //check if wallet for user already exists
    if (await checkIfWalletExists(userID) != null) {
      if (type == 'credit') {
        // Update the wallet balance (assuming it's a credit)
        await walletRef.update({
          'userID': userID,
          'balance': FieldValue.increment(amount),
        });
      } else if (type == 'debit') {
        // Update the wallet balance (assuming it's a debit)
        await walletRef.update({
          'userID': userID,
          'balance': FieldValue.increment(-amount),
        });
      }
    } else {
      if (type == 'credit') {
        // Update the wallet balance (assuming it's a credit)
        await walletRef.set({
          'userID': userID,
          'balance': FieldValue.increment(amount),
          'withdrawable balance': "0",
        });
      } else if (type == 'debit') {
        // Update the wallet balance (assuming it's a debit)
        await walletRef.set({
          'userID': userID,
          'balance': FieldValue.increment(-amount),
        });
      }
    }

    // Add a transaction record
    var transactionID = walletRef.collection('transactions').doc().id;
    await walletRef.collection('transactions').doc(transactionID).set(
      {
        'transaction ID': transactionID,
        'amount': amount,
        'type': type,
        'timestamp': FieldValue.serverTimestamp(),
        'description': description,
      },
    );
  }

  //get wallet balance and get transactions list
  //get wallet balance
  Stream<Wallet> getWalletBalance(String userID) {
    return walletCollection
        .doc(userID)
        .snapshots()
        .map((event) => Wallet.fromJson(event.data() as Map<String, dynamic>));
  }

  //get transactions list and details
  Stream<List<Transactions>> getTransactions(String userID) {
    return walletCollection
        .doc(userID)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) {
      if (event.docs.isEmpty) {
        return <Transactions>[];
      } else {
        return event.docs
            .map((doc) => Transactions.fromJson(doc.data()))
            .toList();
      }
    });
  }

  // request withdrawal
  Future requestWithdrawal(
      String? withdrawalAmount, Map accountDetails, String userID) async {
    try {
      await walletCollection
          .doc(userID)
          .collection("withdrawal requests")
          .doc()
          .set({
        "withdrawal amount": withdrawalAmount,
        "account name": accountDetails["account name"],
        "account number": accountDetails["account number"],
        "bank name": accountDetails["bank name"],
        "timestamp": FieldValue.serverTimestamp(),
        "status": "Not approved",
        "userID": userID,
      });
      return "success";
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  //get vendor withdrawal requests
  Stream<List<WithdrawalRequest>> getWithdrawalRequests(String userId) {
    var result = walletCollection
        .doc(userId)
        .collection("withdrawal requests")
        .snapshots();
    return result.map(
      (event) => event.docs
          .map(
            (doc) => WithdrawalRequest.fromJson(doc.data()),
          )
          .toList(),
    );
  }

  //verify transaction from paystack
  Future<bool> verifyTransaction({
    required String reference,
  }) async {
    String? secretKey = dotenv.env['PAYSTACK_SECRET_KEY'];
    final url = "https://api.paystack.co/transaction/verify/$reference";
    var response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $secretKey"});
    var body = response.body;
    print(jsonDecode(body));
    final data = jsonDecode(body);
    return data["status"];
  }

  //get notifications
  Stream<List<Notifications>> getNotifications() {
    var result = notificationsCollection
        .doc(currentUser!.uid)
        .collection("notifications")
        .orderBy("time stamp", descending: true)
        .snapshots();
    return result.map((event) {
      return event.docs
          .map((doc) => Notifications.fromJson(doc.data()))
          .toList();
    });
  }
}

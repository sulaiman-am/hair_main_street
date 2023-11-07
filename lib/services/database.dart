import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_main_street/models/productModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  User? currentUser = FirebaseAuth.instance.currentUser;

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

  //vendor stuff including vendor profile
  Future createVendor(Vendors vendor) async {
    try {
      var documentID = currentUser!.uid;
      await vendorsCollection.doc(documentID).set({
        "userID": currentUser!.uid,
        "shopName": vendor.shopName,
        "accountInfo": vendor.accountInfo,
        "contactInfo": vendor.contactInfo,
        "isVerified": false,
        "createdAt": FieldValue.serverTimestamp(),
      });
      return "success";
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
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

  //create order and update orders

  //create order
  Future createOrder(Orders order, OrderItem orderItem) async {
    try {
      var role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        var orderRef = ordersCollection.doc();
        var orderID = orderRef.id;

        //create order item subcollection
        ordersCollection.doc(orderID).collection('order items');

        var dbOrder = await ordersCollection.doc(orderID).set({
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

        var dbOrderItem = await ordersCollection
            .doc(orderID)
            .collection('order items')
            .doc(orderID)
            .set({
          "productID": orderItem.productId,
          "quantity": orderItem.quantity,
          "price": orderItem.price,
        });

        // return [
        //   {"order": dbOrder},
        //   {"orderItem": dbOrderItem}
        // ];
      }
    } on FirebaseException catch (e) {
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
        return await ordersCollection.doc(order.orderId).update(updatedFields);
      }
    } on FirebaseException catch (e) {
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
        return await productsCollection
            .doc(product.productID)
            .update(updatedFields);
      } else {
        print("Not Authorized");
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
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
  Future startChat(ChatMessages chatMessage) async {
    try {
      var chatRef = chatCollection.doc();
      var chatID = chatRef.id;
      var fields = {
        "content": chatMessage.content,
        "id To": chatMessage.idTo,
        "id From": chatMessage.idFrom,
        "timestamp": FieldValue.serverTimestamp(),
      };

      //create message subcollection
      return await chatCollection
          .doc(chatID)
          .collection('messages')
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(fields);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //get chats
  Stream<QuerySnapshot> getChats(String chatID, int limit) {
    return chatCollection
        .doc(chatID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();
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
  Future becomeASeller() async {
    try {
      var state = await userProfileCollection.doc(currentUser!.uid).get();
      if (state.exists) {
        var data = state.data() as Map<String, dynamic>;
        if (data['isVendor'] == false) {
          return await userProfileCollection
              .doc(currentUser!.uid)
              .update({"isVendor": true});
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/messageModel.dart';
import 'package:hair_main_street/models/notificationsModel.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/models/referralModel.dart';
import 'package:hair_main_street/models/refund_request_model.dart';
import 'package:hair_main_street/models/review.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/models/vendorsModel.dart';
import 'package:hair_main_street/models/wallet_transaction.dart';
import 'package:hair_main_street/pages/messages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
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

  CollectionReference referralsCollection =
      FirebaseFirestore.instance.collection('referrals');

  CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

  CollectionReference refundsCollection =
      FirebaseFirestore.instance.collection('refunds');

  CollectionReference cancellationCollection =
      FirebaseFirestore.instance.collection('cancellations');

  //get the role dynamically
  Stream<DocumentSnapshot?> get getRoleDynamically {
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
        "result": "success",
        "fullname": user['fullname'],
        "address": user['address'],
        "phoneNumber": user['phonenumber'],
        "profile photo": user['profile photo'],
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

  //update a vendor
  Future updateVendor(String fieldName, value) async {
    try {
      await vendorsCollection
          .doc(currentUser!.uid)
          .set({fieldName: value}, SetOptions(merge: true));
      return "success";
      // var result = await userProfileCollection.doc(currentUser!.uid).get();
      // //result.data() as Map<String, dynamic>;
      // var user = result.data() as Map<String, dynamic>;
      // return {
      //   "fullname": user['fullname'],
      //   "address": user['address'],
      //   "phoneNumber": user['phonenumber']
      // };
    } catch (e) {
      print(e);
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
  Stream<Vendors?> getVendorDetails({String? userID}) {
    try {
      if (currentUser == null) {
        return Stream.error("Current user is null");
      }

      var response = vendorsCollection
          .where('userID', isEqualTo: userID ?? currentUser!.uid)
          .snapshots();

      return response.map((event) {
        if (event.docs.isNotEmpty) {
          var data = event.docs.first.data() as Map<String, dynamic>;
          //print(data);
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

        // Start a transaction to delete the product from the user's cart
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          var cartCollectionRef =
              userProfileCollection.doc(order.buyerId).collection('cart');
          var querySnapshot = await cartCollectionRef
              .where('productID', isEqualTo: orderItem.productId)
              .get();

          // Iterate over the documents in the query snapshot
          for (var doc in querySnapshot.docs) {
            // Get the reference to the document and delete it
            var cartDocRef = doc.reference;
            transaction.delete(cartDocRef);
          }
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

  Future<String?> pickAndSaveImage(ImageSource source, String imagePath) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null; // User canceled or no image selected

      final directory = await getApplicationDocumentsDirectory();
      final fileName = basename(image.path); // Extract filename
      final savePath = '$imagePath/$fileName';
      final fullPath = '${directory.path}/$savePath';

      // Ensure the directory exists
      final saveDir = Directory('${directory.path}/$imagePath');
      if (!await saveDir.exists()) {
        await saveDir.create(
            recursive: true); // Create the directory if it doesn't exist
      }

      final bytes = await File(image.path).readAsBytes();
      await File(fullPath).writeAsBytes(bytes);

      return fullPath; // Return the saved image path
    } on PlatformException catch (e) {
      print("Error picking image: $e");
      return null;
    } catch (e) {
      print("Error saving image: $e");
      return null;
    }
  }

  //create local image file first
  Future<List<File>> createLocalImages() async {
    try {
      List<File> compressedImages = [];
      var appDirectoryPath = await getApplicationDocumentsDirectory();

      //pickFiles
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ["png", "jpg", "jpeg"],
      );

      if (result != null) {
        print("result ${result.paths}");
        for (var image in result.files) {
          var targetPath =
              "${appDirectoryPath.path}/compressed_image${Random().nextInt(1000) + 1}.jpg"; // Add closing parenthesis here
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
          compressedImages.add(finalImage);
        }
      }
      print("compressedImage: $compressedImages");
      return compressedImages;
    } catch (e) {
      print(e);
      return []; // Return an empty list if an error occurs
    }
  }

  //other image uploads
  Future<List<String>> imageUpload(List<File>? images, String imagePath) async {
    List<String> imageUrls = [];

    if (images == null || images.isEmpty) {
      throw Exception('No images provided for upload.');
    }

    try {
      for (File image in images) {
        final storageReference = FirebaseStorage.instance.ref(imagePath);
        final productImageReference = storageReference
            .child(currentUser!.uid)
            .child("compressed_image[${Random().nextInt(1000) + 1}].jpg");

        var uploadTask = productImageReference.putFile(image);

        // Wait for the upload to complete
        await uploadTask;

        // Get download URL
        String downloadURL = await productImageReference.getDownloadURL();

        // Add download URL to list
        imageUrls.add(downloadURL);
      }
      print("image Urls: $imageUrls");
      return imageUrls;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to upload images: $e');
    }
  }

  //image upload for products
  Future<List<String>> uploadProductImage(List<File>? images) async {
    List<String> imageUrls = [];

    if (images == null || images.isEmpty) {
      throw Exception('No images provided for upload.');
    }

    try {
      for (File image in images) {
        final storageReference = FirebaseStorage.instance.ref("productImage");
        final productImageReference = storageReference
            .child(currentUser!.uid)
            .child("compressed_image[${Random().nextInt(1000) + 1}].jpg");

        var uploadTask = productImageReference.putFile(image);

        // Wait for the upload to complete
        await uploadTask;

        // Get download URL
        String downloadURL = await productImageReference.getDownloadURL();

        // Add download URL to list
        imageUrls.add(downloadURL);
      }
      print("image Urls: $imageUrls");
      return imageUrls;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to upload images: $e');
    }
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

        // //create a reviews subcollection
        // productsCollection
        //     .doc(productID)
        //     .collection('reviews')
        //     .doc(productID)
        //     .set({});

        //create the actual product
        await productsCollection.doc(productID).set({
          "productID": productID,
          "name": product!.name,
          "price": product.price,
          "image": product.image,
          "category": product.category,
          "hasOption": product.hasOption,
          "isAvailable": product.isAvailable,
          "isDeleted": product.isDeleted,
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
            "productID": product.productID,
            "name": product.name,
            "category": product.category,
            "isAvailable": product.isAvailable,
            "isDeleted": product.isDeleted,
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

  //client delete product
  Future clientDeleteProduct(Product product) async {
    try {
      var role = await verifyRole();
      if (role!.keys.contains("Vendor") && role["Vendor"] == product.vendorId) {
        await productsCollection.doc(product.productID).set({
          "isDeleted": true,
        }, SetOptions(merge: true));
        return "success";
      } else {
        print('not authorized');
        return 'not authorized';
      }
    } on FirebaseException catch (e) {
      print("${e.message} ${e.code}");
    }
  }

  // admin delete product
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

  // Convert to Product
  List<Product> convertToProduct(QuerySnapshot<Object?> products) {
    if (products.docs.isEmpty) {
      return [];
    }

    return products.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      //print("${Product.fromdata(data)}).toList()}");
      return Product.fromdata(
          data); // Assuming a factory constructor named 'fromData'
    }).toList();
  }

// Fetch products
  Stream<List<Product>> fetchProducts() {
    var stuff = productsCollection.snapshots();
    //print('stuff: $stuff');
    return stuff.map((event) => convertToProduct(event));
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

  //get ,add, edit and delete reviews
  Stream<List<Review?>> getReviews(String productID) {
    try {
      return reviewsCollection
          .where('productID', isEqualTo: productID)
          .snapshots()
          .map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return <Review>[];
        }
        return querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return Review.fromData(data);
        }).toList();
      });
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Stream<List<Review?>> getUserReviews(String userID) {
    // Fetch all products
    try {
      return reviewsCollection
          .where("userID", isEqualTo: userID)
          .snapshots()
          .map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return <Review>[];
        }
        return querySnapshot.docs.map((data) {
          var doc = data.data() as Map<String, dynamic>;
          return Review.fromData(doc);
        }).toList();
      });
    } on FirebaseException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
  }

  Future addAReview(Review review, String productID) async {
    try {
      Product product = await fetchSingleProduct(productID);
      final role = await verifyRole();
      if (role!.keys.contains("Buyer") && product.vendorId != role["Buyer"]) {
        //create review ref and get its id before creating the review
        var reviewID = reviewsCollection.doc().id;
        await reviewsCollection.doc(reviewID).set({
          "review images": review.reviewImages,
          "display name": review.displayName,
          "userID": review.userID,
          "created at": FieldValue.serverTimestamp(),
          "comment": review.comment,
          "stars": review.stars,
          "reviewID": reviewID,
          "extra info": review.extraInfo,
          "productID": productID,
        });
        return "success";
      } else {
        return "Not Authorized";
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  Future deleteReview(String reviewID) async {
    try {
      final role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        return await reviewsCollection.doc(reviewID).delete();
      }
    } on FirebaseException catch (e) {
      print("Error: ${e.code} and ${e.message}");
    }
  }

  //payment stuff

  //referral
  //generate referral code
  String generateReferralCode() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  //generate referral link
  String generateReferralLink(String referralCode) {
    // Replace 'your_domain.com' with your actual domain
    return 'https://hairmainstreet.com/register?referralCode=$referralCode';
  }

  //confirm referral code and reward referrer
  Future<String> confirmRefCodeAndRewardRef({
    String? referralCode,
    String? referredID,
  }) async {
    try {
      int rewardPointToAdd = 10;
      // Query the userProfileCollection to find the user with the given referral code
      var userQuery = await userProfileCollection
          .where("referral code", isEqualTo: referralCode)
          .get();

      // If the user exists
      if (userQuery.docs.isNotEmpty) {
        var userData = userQuery.docs.first.data() as Map<String, dynamic>;
        String referralID = referralsCollection.doc().id;

        // Create a new referral document
        await referralsCollection
            .doc(userData["uid"])
            .collection("referrals")
            .doc(referralID)
            .set({
          "referralID": referralID,
          "referrerID": userData["uid"],
          "referredID": referredID,
          "timestamp": FieldValue.serverTimestamp(),
        });

        // Start a Firestore transaction to update the referrer's reward points
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentReference docRef = referralsCollection.doc(userData["uid"]);
          DocumentSnapshot snapshot = await transaction.get(docRef);

          int? currentValue =
              (snapshot.data() as Map<String, dynamic>?)?["reward point"] ?? 0;

          // If the current value is 0 or null, set the reward points to 10
          if (currentValue == 0) {
            transaction.set(docRef, {"reward point": 10});
          } else {
            // If the current value is greater than 0, update the reward points by adding 10
            transaction.update(docRef, {
              "reward point": FieldValue.increment(rewardPointToAdd),
            });
          }
        });

        return "success";
      } else {
        return "User not found for the given referral code";
      }
    } on FirebaseException catch (e) {
      // Handle Firebase errors more gracefully
      return "Firebase error: ${e.message}";
    } catch (e) {
      // Handle other errors
      return "Error: $e";
    }
  }

  //get referrals
  Stream<List<Referral>> getReferrals() {
    return referralsCollection
        .doc(currentUser!.uid)
        .collection("referrals")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Referral.fromJson(doc.data()))
            .toList());
  }

  //get reward points
  Stream<int> getRewardPoints() {
    var snapshot = referralsCollection.doc(currentUser!.uid).snapshots();
    return snapshot.map((event) {
      final data = event.data();
      if (data != null && data is Map<String, dynamic>) {
        return (data["reward point"] as int?) ?? 0;
      } else {
        // Handle the case when data is null or not of the expected type
        return 0; // Or any default value you prefer
      }
    });
  }

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
          "recent message sent at": FieldValue.serverTimestamp(),
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
        //print(event.docs.map((e) => ChatMessages.fromJson(e.data())).toList());
        yield event.docs.map((e) => ChatMessages.fromJson(e.data())).toList();
      }
    } else {
      // Instead of yielding null, yield an empty list
      yield [];
    }
  }

  //get specific user chats
  Stream<List<DatabaseChatResponse>> getUserChats(String userID) {
    return chatCollection
        .where(Filter.or(
          Filter("member1", isEqualTo: userID),
          Filter("member2", isEqualTo: userID),
        ))
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (doc) => DatabaseChatResponse.fromJson(
                    doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
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

    if (response.statusCode == 200) {
      var body = response.body;
      if (body.isNotEmpty) {
        final data = jsonDecode(body);
        print(data);
        return data["status"];
      } else {
        print("Response body is empty");
        return false;
      }
    } else {
      print("Request failed with status: ${response.statusCode}");
      return false;
    }
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

  //refund and cancellation stuff
  //refund request
  Future submitRefundRequest(RefundRequest refundRequest) async {
    try {
      var role = await verifyRole();
      if (role != null && role.containsKey('Buyer')) {
        String requestID = refundsCollection.doc().id;
        await refundsCollection.doc(requestID).set({
          "userID": refundRequest.userID,
          "requestID": requestID,
          "added details": refundRequest.addedDetails,
          "reason": refundRequest.reason,
          "refund status": "pending",
          "orderID": refundRequest.orderID,
        });
        return "success";
      } else {
        return "not authorized";
      }
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  //cancellation request
  Future submitOrderCancellationRequest(
      CancellationRequest cancellationRequest) async {
    try {
      var role = await verifyRole();
      if (role != null && role.containsKey("Buyer")) {
        String requestID = cancellationCollection.doc().id;
        await cancellationCollection.doc(requestID).set({
          "userID": cancellationRequest.userID,
          "requestID": requestID,
          "reason": cancellationRequest.reason,
          "cancellation status": "pending",
          "orderID": cancellationRequest.orderID,
        });
        return "success";
      } else {
        return "not authorized";
      }
    } on FirebaseException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }
}

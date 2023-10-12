import 'dart:async';
import 'dart:io';
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
        } else {
          throw Exception();
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //create user profile
  Future createUserProfile() async {
    try {
      //create a cart subcollection
      await userProfileCollection
          .doc(uid)
          .collection('cart')
          .doc(uid)
          .set({'Products': []});

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

  //fetch cart products
  Stream<List<dynamic>> fetchCartItems() async* {
    try {
      var role = await verifyRole();
      //print(role);
      if (role!.keys.contains("Buyer")) {
        var result = userProfileCollection
            .doc(role["Buyer"])
            .collection("cart")
            .doc(role["Buyer"])
            .snapshots();
        var test = result;
        yield await test.map((event) {
          var data = event.data() as Map<String, dynamic>;
          //print(data);
          return data["Products"];
        }).toList();
      }
    } catch (e) {
      print(e);
    }

    // Close the Stream.
  }

  //add to cart function
  Future addToCart(Product product) async {
    try {
      var element = FieldValue.arrayUnion([product]);
      var role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        await userProfileCollection
            .doc(role["Buyer"])
            .collection('cart')
            .doc(role["Buyer"])
            .update({"Products": element});
        return "Success";
      } else {
        print("Not Authorized");
      }
    } catch (e) {
      print(e);
    }
  }

  //create order and update orders

  //image upload for products
  Future<List<dynamic>?> uploadProductImage() async {
    try {
      //actual image
      List<dynamic> productImageList = [];
      dynamic productImage;
      var appDirectoryPath = await getApplicationDocumentsDirectory();
      //pickFile
      final result = await FilePicker.platform.pickFiles(
        //type: FileType.any,
        allowMultiple: true,
        //allowedExtensions: ["png", "jpg", "jpeg"],
      );
      if (result != null) {
        print("result ${result.paths}");
        for (var image in result.files) {
          var targetPath =
              "${appDirectoryPath.path}/compressed_image[${result.files.indexOf(image)}].jpg";
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
              .child("compress_image[${result.files.indexOf(image)}]");
          productImage = await productImageReference.putFile(finalImage);
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
        return await productsCollection.doc().set({
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
      } else {
        print("Not Authorized");
      }
    } catch (e) {
      print("catch error $e");
    }
  }

  //update product
  Future updateProduct({String? fieldName, dynamic value, id}) async {
    try {
      //ensure only user with appropriate role can add product
      //get the current user role
      var role = await verifyRole();
      if (role!.keys.contains("Vendor")) {
        return await productsCollection.doc(id).update({"$fieldName": value});
      } else {
        print("Not Authorized");
      }
    } catch (e) {
      print(e);
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
    print(stuff);
    return stuff.map(
      (event) => convertToProduct(event),
    );
  }

  //fetch single product
  Future fetchSingleProduct(dynamic id) async {
    DocumentSnapshot snapshot = await productsCollection.doc(id).get();
    if (snapshot.exists) {
      var product = snapshot.data() as Product;
      print(product);
      product.vendorId = id;
      print(product);
      return product;
    }
  }

  //payment stuff

  //referral

  //chats
}

import 'package:hair_main_street/models/userModel.dart';

class CheckOutTickBoxModel {
  String? productID;
  num? price;
  int? quantity;
  MyUser? user;

  CheckOutTickBoxModel({this.price, this.productID, this.quantity, this.user});
}

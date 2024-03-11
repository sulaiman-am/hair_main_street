import 'package:hair_main_street/models/userModel.dart';

class CheckOutTickBoxModel {
  String? productID;
  dynamic price;
  dynamic quantity;
  MyUser? user;

  CheckOutTickBoxModel({this.price, this.productID, this.quantity, this.user});
}

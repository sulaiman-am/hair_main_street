import 'package:get/get.dart';
import 'package:hair_main_street/models/cartItemModel.dart';
import 'package:hair_main_street/models/orderModel.dart';
import 'package:hair_main_street/models/userModel.dart';
import 'package:hair_main_street/services/database.dart';

class CheckOutController extends GetxController {
  Rx<CheckoutItem> checkOutItem = CheckoutItem().obs;
  Rx<Orders?> order = Rx<Orders?>(null);
  Rx<OrderItem?> orderItem = Rx<OrderItem?>(null);

  createCheckOutItem(
    String productID,
    quantity,
    price,
    MyUser user,
  ) {
    checkOutItem.value = CheckoutItem(
      productId: productID,
      quantity: quantity.toString(),
      price: price.toString(),
      fullName: user.fullname,
      address: user.address,
      phoneNumber: user.phoneNumber,
      createdAt: DateTime.now().toString(),
    );
    return checkOutItem.value;
  }

  createOrder(String paymentMethod) async {
    order.value = Orders(
      shippingAddress: checkOutItem.value.address,
      totalPrice: int.parse(checkOutItem.value.price!),
      paymentMethod: paymentMethod,
      paymentStatus: "paid",
      orderStatus: "created",
    );
    orderItem.value = OrderItem(
        productId: checkOutItem.value.productId,
        quantity: checkOutItem.value.quantity,
        price: checkOutItem.value.price);

    await DataBaseService().createOrder(order.value!, orderItem.value!);
  }
}

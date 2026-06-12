import 'package:olshopapp/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<void> submitCart({
    required String uid,
    required List<CartItem> items,
    required String recipientName,
    required String address,
    required String paymentMethod,
    required double subtotal,
    required double shippingFee,
    required double discount,
    required double totalPayment,
  });
}

import 'package:olshopapp/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:olshopapp/features/cart/domain/entities/cart_item.dart';
import 'package:olshopapp/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
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
  }) async {
          await remoteDataSource.submitCart(
      uid: uid,
      items: items,
      recipientName: recipientName,
         address: address,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      shippingFee: shippingFee,
      discount: discount,
      totalPayment: totalPayment,
          );
  }
}

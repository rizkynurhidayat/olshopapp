import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  const CartState({this.items = const []});

  
  double get totalPrice => items.fold(0, (sum, item) {
    final price = item.product.discountPrice ?? item.product.price;
    return sum + (price * item.quantity);
  });

  @override
  List<Object> get props => [items];
}

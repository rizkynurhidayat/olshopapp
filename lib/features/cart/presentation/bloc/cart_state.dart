import 'package:equatable/equatable.dart';
import 'package:olshopapp/features/cart/domain/entities/cart_item.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final List<CartItem> items;
  final CartStatus status;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.status = CartStatus.initial,
    this.errorMessage,
  });

  double get totalPrice => items.fold(0, (sum, item) {
    final price = item.product.discountPrice ?? item.product.price;
    return sum + (price * item.quantity);
  });

  CartState copyWith({
    List<CartItem>? items,
    CartStatus? status,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, status, errorMessage];
}

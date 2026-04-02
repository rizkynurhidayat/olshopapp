import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../../shop/domain/entities/product.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 2)
class CartItem extends Equatable {
  @HiveField(0)
  final Product product;
  @HiveField(1)
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:olshopapp/features/shop/domain/entities/product.dart';

class OrderEntity extends Equatable {
  final String id;
  final List<OrderItemEntity> items;
  final double totalPrice;
  final DateTime date;
  final String status; // 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'

  const OrderEntity({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.date,
    required this.status,
  });

  @override
  List<Object?> get props => [id, items, totalPrice, date, status];
}

class OrderItemEntity extends Equatable {
  final Product product;
  final int quantity;

  const OrderItemEntity({
    required this.product,
    required this.quantity,
  });

  @override
  List<Object?> get props => [product, quantity];
}

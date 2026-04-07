import '../../domain/entities/order.dart';
import '../../../shop/data/models/product_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.items,
    required super.totalPrice,
    required super.date,
    required super.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      items: (json['items'] as List)
          .map((i) => OrderItemModel.fromJson(i))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((i) => (i as OrderItemModel).toJson()).toList(),
      'totalPrice': totalPrice,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      items: entity.items
          .map((i) => OrderItemModel.fromEntity(i))
          .toList(),
      totalPrice: entity.totalPrice,
      date: entity.date,
      status: entity.status,
    );
  }
}

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.product,
    required super.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': (product as ProductModel).toJson(),
      'quantity': quantity,
    };
  }

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      product: entity.product,
      quantity: entity.quantity,
    );
  }
}

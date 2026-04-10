import 'package:equatable/equatable.dart';
import 'package:olshopapp/features/shop/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);
  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
  @override
  List<Object?> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;
  UpdateQuantity(this.productId, this.quantity);
  @override
  List<Object?> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}

class SubmitCart extends CartEvent {
  final String uid;
  final String recipientName;
  final String address;
  final String paymentMethod;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double totalPayment;

  SubmitCart({
    required this.uid,
    required this.recipientName,
    required this.address,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.totalPayment,
  });

  @override
  List<Object?> get props => [
    uid,
    recipientName,
    address,
    paymentMethod,
    subtotal,
    shippingFee,
    discount,
    totalPayment,
  ];
}

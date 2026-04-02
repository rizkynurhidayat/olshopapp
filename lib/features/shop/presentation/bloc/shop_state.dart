import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ShopState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final List<Product> products;
  ShopLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ShopError extends ShopState {
  final String message;
  ShopError(this.message);

  @override
  List<Object?> get props => [message];
}

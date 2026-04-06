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
  final bool hasReachedMax;
  final bool isLoadingMore;

  ShopLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ShopLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ShopLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasReachedMax, isLoadingMore];
}

class ShopError extends ShopState {
  final String message;
  ShopError(this.message);

  @override
  List<Object?> get props => [message];
}

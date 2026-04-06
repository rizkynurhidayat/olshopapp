import 'package:equatable/equatable.dart';

abstract class ShopEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends ShopEvent {}

class LoadMoreProductsEvent extends ShopEvent {}

class SearchProductsEvent extends ShopEvent {
  final String query;
  SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategoryEvent extends ShopEvent {
  final String category;
  FilterByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

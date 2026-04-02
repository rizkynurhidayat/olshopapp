import 'package:equatable/equatable.dart';

abstract class ShopEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends ShopEvent {}

class SearchProductsEvent extends ShopEvent {
  final String query;
  SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

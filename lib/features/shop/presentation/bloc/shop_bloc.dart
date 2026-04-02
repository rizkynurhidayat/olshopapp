import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/search_products.dart';
import 'shop_event.dart';
import 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final GetProducts getProducts;
  final SearchProducts searchProducts;

  ShopBloc({
    required this.getProducts,
    required this.searchProducts,
  }) : super(ShopInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ShopLoading());
      final result = await getProducts(NoParams());
      result.fold(
        (failure) => emit(ShopError(failure.message)),
        (products) => emit(ShopLoaded(products)),
      );
    });

    on<SearchProductsEvent>((event, emit) async {
      emit(ShopLoading());
      final result = await searchProducts(event.query);
      result.fold(
        (failure) => emit(ShopError(failure.message)),
        (products) => emit(ShopLoaded(products)),
      );
    });
  }
}

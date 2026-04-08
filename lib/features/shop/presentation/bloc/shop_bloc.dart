import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/core/usecase/usecase.dart';
import 'package:olshopapp/features/shop/domain/entities/product.dart';
import 'package:olshopapp/features/shop/domain/usecases/get_products.dart';
import 'package:olshopapp/features/shop/domain/usecases/search_products.dart';
import 'package:olshopapp/features/shop/presentation/bloc/shop_event.dart';
import 'package:olshopapp/features/shop/presentation/bloc/shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final GetProducts getProducts;
  final SearchProducts searchProducts;
  
  static const int _limit = 10;
  List<Product> _allProducts = [];
  String _currentCategory = 'All';

  ShopBloc({
    required this.getProducts,
    required this.searchProducts,
  }) : super(ShopInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ShopLoading());
      final result = await getProducts(NoParams());
      result.fold(
        (failure) => emit(ShopError(failure.message)),
        (products) {
          _allProducts = products;
          _currentCategory = 'All';
          final initialProducts = _allProducts.take(_limit).toList();
          emit(ShopLoaded(
            products: initialProducts,
            hasReachedMax: _allProducts.length <= _limit,
          ));
        },
      );
    });

    on<LoadMoreProductsEvent>((event, emit) async {
      final currentState = state;
      if (currentState is ShopLoaded && !currentState.hasReachedMax && !currentState.isLoadingMore) {
        emit(currentState.copyWith(isLoadingMore: true));
        
        // Simulasikan delay loading
        await Future.delayed(const Duration(seconds: 1));
        
        final currentProducts = currentState.products;
        final nextProducts = _getFilteredProducts()
            .skip(currentProducts.length)
            .take(_limit)
            .toList();
            
        emit(ShopLoaded(
          products: currentProducts + nextProducts,
          hasReachedMax: (currentProducts.length + nextProducts.length) >= _getFilteredProducts().length,
          isLoadingMore: false,
        ));
      }
    });

    on<FilterByCategoryEvent>((event, emit) async {
      _currentCategory = event.category;
      final filtered = _getFilteredProducts();
      final initialProducts = filtered.take(_limit).toList();
      emit(ShopLoaded(
        products: initialProducts,
        hasReachedMax: filtered.length <= _limit,
      ));
    });

    on<SearchProductsEvent>((event, emit) async {
      emit(ShopLoading());
      final result = await searchProducts(event.query);
      result.fold(
        (failure) => emit(ShopError(failure.message)),
        (products) {
          final initialProducts = products.take(_limit).toList();
          emit(ShopLoaded(
            products: initialProducts,
            hasReachedMax: products.length <= _limit,
          ));
        },
      );
    });
  }

  List<Product> _getFilteredProducts() {
    if (_currentCategory == 'All') {
      return _allProducts;
    }
    return _allProducts.where((p) => p.category == _currentCategory).toList();
  }
}

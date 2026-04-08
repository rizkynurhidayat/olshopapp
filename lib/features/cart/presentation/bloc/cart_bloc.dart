import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/core/storage/local_storage.dart';
import 'package:olshopapp/features/cart/domain/entities/cart_item.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final LocalStorage localStorage;

  CartBloc({required this.localStorage}) : super(const CartState(items: [])) {
    on<LoadCart>((event, emit) async {
      final items = await localStorage.getCartItems();
      emit(CartState(items: items));
    });

    on<AddToCart>((event, emit) async {
      final updatedItems = List<CartItem>.from(state.items);
      final index = updatedItems.indexWhere((item) => item.product.id == event.product.id);
      
      if (index >= 0) {
        updatedItems[index] = updatedItems[index].copyWith(quantity: updatedItems[index].quantity + 1);
      } else {
        updatedItems.add(CartItem(product: event.product, quantity: 1));
      }
      await localStorage.saveCartItems(updatedItems);
      emit(CartState(items: updatedItems));
    });

    on<UpdateQuantity>((event, emit) async {
      final updatedItems = List<CartItem>.from(state.items);
      final index = updatedItems.indexWhere((item) => item.product.id == event.productId);
      
      if (index >= 0) {
        if (event.quantity > 0) {
          updatedItems[index] = updatedItems[index].copyWith(quantity: event.quantity);
        } else {
          updatedItems.removeAt(index);
        }
        await localStorage.saveCartItems(updatedItems);
        emit(CartState(items: updatedItems));
      }
    });

    on<RemoveFromCart>((event, emit) async {
      final updatedItems = state.items.where((item) => item.product.id != event.productId).toList();
      await localStorage.saveCartItems(updatedItems);
      emit(CartState(items: updatedItems));
    });

    on<ClearCart>((event, emit) async {
      await localStorage.clearCart();
      emit(const CartState(items: []));
    });
  }
}

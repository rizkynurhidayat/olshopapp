import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/local_storage.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final LocalStorage localStorage;

  CartBloc({required this.localStorage}) : super(CartState(items: localStorage.getCartItems())) {
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

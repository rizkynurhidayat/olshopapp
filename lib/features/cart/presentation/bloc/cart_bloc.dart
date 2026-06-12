import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/core/storage/local_storage.dart';
import 'package:olshopapp/features/cart/domain/entities/cart_item.dart';
import 'package:olshopapp/features/cart/domain/repositories/cart_repository.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final LocalStorage localStorage;
  final CartRepository cartRepository;

  CartBloc({
    required this.localStorage,
    required this.cartRepository,
  }) : super(const CartState()) {
    on<LoadCart>((event, emit) async {
      emit(state.copyWith(status: CartStatus.loading));
      try {
        final items = await localStorage.getCartItems();
        emit(CartState(items: items, status: CartStatus.success));
      } catch (e) {
        emit(state.copyWith(status: CartStatus.failure, errorMessage: e.toString()));
      }
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
      emit(state.copyWith(items: updatedItems, status: CartStatus.success));
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
        emit(state.copyWith(items: updatedItems, status: CartStatus.success));
      }
    });

    on<RemoveFromCart>((event, emit) async {
      final updatedItems = state.items.where((item) => item.product.id != event.productId).toList();
      await localStorage.saveCartItems(updatedItems);
      emit(state.copyWith(items: updatedItems, status: CartStatus.success));
    });

    on<ClearCart>((event, emit) async {
      await localStorage.clearCart();
      emit(const CartState(items: [], status: CartStatus.success));
    });

    on<SubmitCart>((event, emit) async {
      if (state.items.isEmpty) return;

      emit(state.copyWith(status: CartStatus.loading));
      try {
        await cartRepository.submitCart(
          uid: event.uid,
          items: state.items,
          recipientName: event.recipientName,
          address: event.address,
          paymentMethod: event.paymentMethod,
          subtotal: event.subtotal,
          shippingFee: event.shippingFee,
          discount: event.discount,
          totalPayment: event.totalPayment,
        );
        await localStorage.clearCart();
        emit(const CartState(items: [], status: CartStatus.success));
        
      } catch (e) {
        emit(state.copyWith(status: CartStatus.failure, errorMessage: e.toString()));
      }
    });
  }
}

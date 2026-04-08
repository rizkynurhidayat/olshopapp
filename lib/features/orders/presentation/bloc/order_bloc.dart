import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/core/usecase/usecase.dart';
import 'package:olshopapp/features/orders/domain/entities/order.dart';
import 'package:olshopapp/features/orders/domain/usecases/get_orders.dart';
import 'package:olshopapp/features/orders/domain/usecases/save_order.dart';

// Events
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrders extends OrderEvent {}

class AddOrder extends OrderEvent {
  final OrderEntity order;

  const AddOrder(this.order);

  @override
  List<Object?> get props => [order];
}

// States
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderEntity> orders;

  const OrderLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrders getOrders;
  final SaveOrder saveOrder;

  OrderBloc({required this.getOrders, required this.saveOrder}) : super(OrderInitial()) {
    on<FetchOrders>((event, emit) async {
      emit(OrderLoading());
      final failureOrOrders = await getOrders(NoParams());
      failureOrOrders.fold(
        (failure) => emit(OrderError(failure.message)),
        (orders) => emit(OrderLoaded(orders)),
      );
    });

    on<AddOrder>((event, emit) async {
      final failureOrSuccess = await saveOrder(event.order);
      failureOrSuccess.fold(
        (failure) => emit(OrderError(failure.message)),
        (_) => add(FetchOrders()),
      );
    });
  }
}

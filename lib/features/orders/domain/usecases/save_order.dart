import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/core/usecase/usecase.dart';
import 'package:olshopapp/features/orders/domain/entities/order.dart';
import 'package:olshopapp/features/orders/domain/repositories/order_repository.dart';

class SaveOrder implements UseCase<void, OrderEntity> {
  final OrderRepository repository;

  SaveOrder(this.repository);

  @override
  Future<Either<Failure, void>> call(OrderEntity order) async {
    return await repository.saveOrder(order);
  }
}

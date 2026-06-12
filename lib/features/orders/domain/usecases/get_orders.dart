import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/core/usecase/usecase.dart';
import 'package:olshopapp/features/orders/domain/entities/order.dart';
import 'package:olshopapp/features/orders/domain/repositories/order_repository.dart';

class GetOrders implements UseCase<List<OrderEntity>, String> {
  final OrderRepository repository;

  GetOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(String uid) async {
    return await repository.getOrders(uid);
  }
}

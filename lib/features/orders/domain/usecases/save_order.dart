import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class SaveOrder implements UseCase<void, OrderEntity> {
  final OrderRepository repository;

  SaveOrder(this.repository);

  @override
  Future<Either<Failure, void>> call(OrderEntity order) async {
    return await repository.saveOrder(order);
  }
}

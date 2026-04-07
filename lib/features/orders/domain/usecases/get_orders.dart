import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrders implements UseCase<List<OrderEntity>, NoParams> {
  final OrderRepository repository;

  GetOrders(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    return await repository.getOrders();
  }
}

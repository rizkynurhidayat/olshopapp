import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final orders = await localDataSource.getOrders();
      return Right(orders);
    } catch (e) {
      return Left(CacheFailure('Failed to load orders from cache'));
    }
  }

  @override
  Future<Either<Failure, void>> saveOrder(OrderEntity order) async {
    try {
      final orderModel = OrderModel.fromEntity(order);
      await localDataSource.saveOrder(orderModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save order to cache'));
    }
  }
}

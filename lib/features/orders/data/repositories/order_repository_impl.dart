import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/features/orders/domain/entities/order.dart';
import 'package:olshopapp/features/orders/domain/repositories/order_repository.dart';
import 'package:olshopapp/features/orders/data/datasources/order_local_data_source.dart';
import 'package:olshopapp/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:olshopapp/features/orders/data/models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders(String uid) async {
    try {
      final orders = await remoteDataSource.getOrders(uid);
      // We can also cache them here if needed
      return Right(orders);
    } catch (e) {
      // Fallback to local data if remote fails
      try {
        final localOrders = await localDataSource.getOrders();
        return Right(localOrders);
      } catch (localError) {
        return Left(ServerFailure('Failed to load orders from remote and cache'));
      }
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

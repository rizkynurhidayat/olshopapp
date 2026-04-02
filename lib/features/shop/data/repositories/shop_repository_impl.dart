import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_remote_data_source.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDataSource remoteDataSource;

  ShopRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final remoteProducts = await remoteDataSource.getProducts();
      return Right(remoteProducts);
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch products'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final remoteProducts = await remoteDataSource.getProducts();
      final filtered = remoteProducts
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return Right(filtered);
    } catch (e) {
      return const Left(ServerFailure('Failed to search products'));
    }
  }
}

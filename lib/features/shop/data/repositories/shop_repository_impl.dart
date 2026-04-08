import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/features/shop/domain/entities/product.dart';
import 'package:olshopapp/features/shop/domain/repositories/shop_repository.dart';
import 'package:olshopapp/features/shop/data/datasources/shop_remote_data_source.dart';

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
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final remoteProduct = await remoteDataSource.getProductById(id);
      return Right(remoteProduct);
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch product detail'));
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

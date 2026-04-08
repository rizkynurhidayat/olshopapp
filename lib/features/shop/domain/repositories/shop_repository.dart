import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/features/shop/domain/entities/product.dart';

abstract class ShopRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}

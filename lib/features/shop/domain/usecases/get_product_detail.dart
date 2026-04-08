import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/core/usecase/usecase.dart';
import 'package:olshopapp/features/shop/domain/entities/product.dart';
import 'package:olshopapp/features/shop/domain/repositories/shop_repository.dart';

class GetProductDetail implements UseCase<Product, String> {
  final ShopRepository repository;

  GetProductDetail(this.repository);

  @override
  Future<Either<Failure, Product>> call(String params) async {
    return await repository.getProductById(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:olshopapp/core/error/failures.dart';
import 'package:olshopapp/core/usecase/usecase.dart';
import 'package:olshopapp/features/shop/domain/entities/product.dart';
import 'package:olshopapp/features/shop/domain/repositories/shop_repository.dart';

class GetProducts implements UseCase<List<Product>, NoParams> {
  final ShopRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return await repository.getProducts();
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/shop_repository.dart';

class SearchProducts implements UseCase<List<Product>, String> {
  final ShopRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String query) async {
    return await repository.searchProducts(query);
  }
}

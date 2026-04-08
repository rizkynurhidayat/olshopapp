import 'package:dio/dio.dart';
import 'package:olshopapp/features/shop/data/models/product_model.dart';

abstract class ShopRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final Dio dio;
  static const String _baseUrl = 'https://v1.appbackend.io/v1/rows/eba2Bq63LkQT';

  ShopRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get(_baseUrl);

    if (response.statusCode == 200) {
      return (response.data['data'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await dio.get('$_baseUrl/$id');

    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load product by ID');
    }
  }
}

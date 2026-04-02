import 'package:dio/dio.dart';
import '../models/product_model.dart';
import 'product_dummy_data.dart';

abstract class ShopRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final Dio dio;

  ShopRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('https://fakestoreapi.com/products');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } else {
      throw Exception();
    }
  }
}

class MockShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    // Memberikan delay seolah-olah sedang mengambil data dari internet
    await Future.delayed(const Duration(seconds: 1));
    return ProductDummyData.products;
  }
}

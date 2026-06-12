import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:olshopapp/features/orders/data/models/order_model.dart';
import 'package:olshopapp/features/shop/data/models/product_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders(String uid);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  final String url = 'https://v1.appbackend.io/v1/rows/ZHSSHlKENp9r';

  OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<OrderModel>> getOrders(String uid) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'filterKey': 'uid',
          'filterValue': uid,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) {
          // Parse the specific format from appbackend.io
          final String listOrderStr = json['list_order'];
          final List<dynamic> listOrderJson = jsonDecode(listOrderStr);
          
          final items = listOrderJson.map((item) {
            return OrderItemModel(
              product: ProductModel(
                id: item['id'] ?? '',
                title: item['title'] ?? '',
                price: double.tryParse(item['price']?.toString() ?? '0') ?? 0.0,
                description: '',
                category: '',
                image: '',
              ),
              quantity: item['quantity'],
            );
          }).toList();

          return OrderModel(
            id: json['_id'],
            items: items,
            totalPrice: double.parse(json['total_price']),
            date: DateTime.parse(json['created_at']),
            status: json['status'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }
}

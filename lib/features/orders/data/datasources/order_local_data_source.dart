import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> saveOrder(OrderModel order);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final LocalStorage localStorage;
  Box? _box;

  OrderLocalDataSourceImpl({required this.localStorage});

  Future<Box> _openBox() async {
    final user = localStorage.getUser();
    if (user == null) throw Exception('User not logged in');
    
    final boxName = 'orders_${user.id}';
    if (_box == null || !_box!.isOpen || _box!.name != boxName) {
      _box = await Hive.openBox(boxName);
    }
    return _box!;
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final box = await _openBox();
      final List<dynamic> ordersList = box.values.toList();
      return ordersList.map((orderData) {
        final Map<String, dynamic> mappedData = _convertToMap(orderData);
        return OrderModel.fromJson(mappedData);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    try {
      final box = await _openBox();
      await box.add(order.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _convertToMap(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(
        data.map((key, value) => MapEntry(key.toString(), _processValue(value))),
      );
    }
    return {};
  }

  dynamic _processValue(dynamic value) {
    if (value is Map) {
      return _convertToMap(value);
    } else if (value is List) {
      return value.map((e) => _processValue(e)).toList();
    }
    return value;
  }
}

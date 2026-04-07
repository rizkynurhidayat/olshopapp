import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/order_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> saveOrder(OrderModel order);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  static const String _orderBoxName = 'orderBox';

  @override
  Future<List<OrderModel>> getOrders() async {
    final box = await Hive.openBox(_orderBoxName);
    final List<dynamic> ordersJson = box.values.toList();
    return ordersJson.map((json) => OrderModel.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    final box = await Hive.openBox(_orderBoxName);
    await box.add(order.toJson());
  }
}

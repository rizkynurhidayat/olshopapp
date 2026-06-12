import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:olshopapp/features/cart/domain/entities/cart_item.dart';

abstract class CartRemoteDataSource {
  Future<void> submitCart({
    required String uid,
    required List<CartItem> items,
    required String recipientName,
    required String address,
    required String paymentMethod,
    required double subtotal,
    required double shippingFee,
    required double discount,
    required double totalPayment,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio;
  final String apiUrl = 'https://v1.appbackend.io/v1/rows/oCYKF9kAxDmX';
  final String paymentHistoryUrl = 'https://v1.appbackend.io/v1/rows/ZHSSHlKENp9r';

  CartRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> submitCart({
    required String uid,
    required List<CartItem> items,
    required String recipientName,
    required String address,
    required String paymentMethod,
    required double subtotal,
    required double shippingFee,
    required double discount,
    required double totalPayment,
  }) async {
    try {
      final String listOrderJson = jsonEncode(items.map((item) {
        final price = item.product.discountPrice ?? item.product.price;
        return {
          'id': item.product.id,
          'title': item.product.title,
          'quantity': item.quantity,
          'price': price.toStringAsFixed(3),
        };
      }).toList());

      final String createdAt = DateTime.now().toIso8601String();
      final String formattedTotal = totalPayment.toStringAsFixed(3);

      // 1. Submit Order
      final orderData = [
        {
          "uid": uid,
          "recipient_name": recipientName,
          "list_order": listOrderJson,
          "address": address,
          "payment_method": paymentMethod,
          "subtotal": subtotal.toStringAsFixed(3),
          "shipping_fee": shippingFee.toStringAsFixed(3),
          "discount": discount.toStringAsFixed(3),
          "total_payment": formattedTotal,
          "created_at": createdAt,
        }
      ];

      final orderResponse = await dio.post(apiUrl, data: orderData);

      if (orderResponse.statusCode != 200 && orderResponse.statusCode != 201) {
        throw Exception('Failed to submit order');
      }

      // 2. Get ID from the new order and Submit Payment History
      // appbackend.io usually returns the created rows in the data field as a list
      String? orderId;
      try {
        if (orderResponse.data is List && (orderResponse.data as List).isNotEmpty) {
          orderId = orderResponse.data[0]['_id']?.toString();
        } else if (orderResponse.data is Map) {
          // Fallback if it returns a single object or has nested results
          orderId = orderResponse.data['_id']?.toString() ?? orderResponse.data['id']?.toString();
        }
      } catch (e) {
        debugPrint("Error extracting order ID: $e");
      }

      if (orderId != null) {
        final paymentData = [
          {
            "order_id": orderId,
            "list_order": listOrderJson,
            "status": "Success",
            "total_price": formattedTotal,
            "created_at": createdAt,
            "uid": uid,
          }
        ];

        await dio.post(paymentHistoryUrl, data: paymentData);
      } else {
        debugPrint("Warning: Could not extract order ID, payment history not created.");
      }

    } on DioException catch (e) {
      throw Exception(e.message ?? 'An error occurred while submitting cart');
    } catch (e) {
      throw Exception('An unexpected error occurred while submitting cart: $e');
    }
  }
}

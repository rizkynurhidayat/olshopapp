import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olshopapp/core/themes/theme.dart';
import 'package:olshopapp/features/orders/domain/entities/order.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderEntity order;

  const OrderItemWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID: ${order.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd MMM yyyy, HH:mm').format(order.date),
            style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
          ),
          const Divider(height: 24),
          ...order.items.take(2).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.product.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.broken_image, size: 40),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${item.quantity} x Rp. ${item.product.price.toStringAsFixed(3)}',
                        style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          if (order.items.length > 2)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                '+${order.items.length - 2} more items',
                style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
              ),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payment',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Rp. ${order.totalPrice.toStringAsFixed(3)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPink,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Delivered':
        bgColor = Colors.green.shade50;
        textColor = Colors.green;
        break;
      case 'Processing':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue;
        break;
      case 'Shipped':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange;
        break;
      case 'Cancelled':
        bgColor = Colors.red.shade50;
        textColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

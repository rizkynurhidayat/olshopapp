import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/core/themes/theme.dart';
import 'package:olshopapp/features/orders/presentation/bloc/order_bloc.dart';
import 'package:olshopapp/features/orders/presentation/widgets/order_item.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Purchase History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryPink));
          } else if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return _buildEmptyOrders();
            }
            final listOrders = state.orders.reversed.toList();
            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: listOrders.length,
              itemBuilder: (context, index) {
                
                final order = listOrders[index];
                return OrderItemWidget(order: order);
              },
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No history found'));
        },
      ),
    );
  }

  Widget _buildEmptyOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          const Text(
            'No orders yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Your purchase history will appear here',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

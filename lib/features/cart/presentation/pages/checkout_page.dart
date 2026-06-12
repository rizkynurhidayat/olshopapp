import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/core/themes/theme.dart';
import 'package:olshopapp/features/orders/domain/entities/order.dart';
import 'package:olshopapp/features/orders/presentation/bloc/order_bloc.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_state.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPaymentMethod = 'Credit Card';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state.status == CartStatus.success && state.items.isEmpty) {
             _showSuccessDialog(context);
          }
          if (state.status == CartStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Submission failed')),
            );
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shipping Address Section
                        _buildSectionTitle('Shipping Address'),
                        const SizedBox(height: 12),
                        _buildCard(
                          child: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.primaryPink),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.background.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: addressController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Complete Address',
                                  prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primaryPink),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.background.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Payment Method Section
                        _buildSectionTitle('Payment Method'),
                        const SizedBox(height: 12),
                        _buildCard(
                          child: Column(
                            children: [
                              _buildPaymentOption(
                                icon: Icons.credit_card,
                                title: 'Credit Card',
                                isSelected: selectedPaymentMethod == 'Credit Card',
                                onTap: () => setState(() => selectedPaymentMethod = 'Credit Card'),
                              ),
                              const Divider(height: 24),
                              _buildPaymentOption(
                                icon: Icons.account_balance_wallet_outlined,
                                title: 'Digital Wallet',
                                isSelected: selectedPaymentMethod == 'Digital Wallet',
                                onTap: () => setState(() => selectedPaymentMethod = 'Digital Wallet'),
                              ),
                              const Divider(height: 24),
                              _buildPaymentOption(
                                icon: Icons.payments_outlined,
                                title: 'Cash on Delivery',
                                isSelected: selectedPaymentMethod == 'Cash on Delivery',
                                onTap: () => setState(() => selectedPaymentMethod = 'Cash on Delivery'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Order Summary Section
                        _buildSectionTitle('Order Summary'),
                        const SizedBox(height: 12),
                        _buildCard(
                          child: Column(
                            children: [
                              _buildSummaryRow('Subtotal', 'Rp. ${cartState.totalPrice.toStringAsFixed(3)}'),
                              const SizedBox(height: 12),
                              _buildSummaryRow('Shipping Fee', 'Rp. 15.000'),
                              const SizedBox(height: 12),
                              _buildSummaryRow('Discount', 'Rp. 0', isDiscount: true),
                              const Divider(height: 24),
                              _buildSummaryRow(
                                'Total Payment', 
                                'Rp. ${(cartState.totalPrice + 15.000).toStringAsFixed(3)}',
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                
                // Bottom Action
                _buildBottomAction(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryPink),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const Spacer(),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryPink : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryPink,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.primaryText : AppColors.secondaryText,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isDiscount 
                ? Colors.green 
                : (isTotal ? AppColors.primaryPink : AppColors.primaryText),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: cartState.status == CartStatus.loading ? null : () {
                      final name = nameController.text.trim();
                      final address = addressController.text.trim();

                      if (name.isEmpty || address.isEmpty || selectedPaymentMethod.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all fields')),
                        );
                        return;
                      }

                      String uid = '';
                      if (authState is Authenticated) {
                        uid = authState.user.id;
                      }

                      final order = OrderEntity(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        items: cartState.items.map((item) => OrderItemEntity(
                          product: item.product,
                          quantity: item.quantity,
                        )).toList(),
                        totalPrice: cartState.totalPrice + 15.000,
                        date: DateTime.now(),
                        status: 'Processing',
                      );
                      context.read<OrderBloc>().add(AddOrder(order));
                      context.read<CartBloc>().add(SubmitCart(
                        uid: uid,
                        recipientName: name,
                        address: address,
                        paymentMethod: selectedPaymentMethod,
                        subtotal: cartState.totalPrice,
                        shippingFee: 15.000,
                        discount: 0,
                        totalPayment: cartState.totalPrice + 15.000,
                      ));
                    },
                    child: cartState.status == CartStatus.loading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirm Order',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Successful!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Your beauty package will be processed and shipped soon. Thank you for shopping!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

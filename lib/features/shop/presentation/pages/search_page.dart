import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/shop/presentation/widgets/product.dart';
import '../../../../core/themes/theme.dart';
import '../bloc/shop_bloc.dart';
import '../bloc/shop_event.dart';
import '../bloc/shop_state.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';

class SearchPage extends StatelessWidget {
  final bool isContent;
  const SearchPage({super.key, this.isContent = false});

  @override
  Widget build(BuildContext context) {
    final searchField = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: AppColors.primaryPink),
          hintText: 'Search product, kit or brand...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: AppColors.secondaryText.withOpacity(0.6)),
        ),
        onChanged: (query) {
          context.read<ShopBloc>().add(SearchProductsEvent(query));
        },
      ),
    );

    final results = BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ShopLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryPink));
        }
        if (state is ShopError) return Center(child: Text(state.message));
        if (state is ShopLoaded) {
          if (state.products.isEmpty) {
            return const Center(child: Text('No products found', style: TextStyle(color: AppColors.secondaryText)));
          }
          return GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductCard(
                product: product,
                onAddToCart: () {
                  context.read<CartBloc>().add(AddToCart(product));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                },
              );
            },
          );
        }
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text('Start searching for your favorites...', style: TextStyle(color: AppColors.secondaryText)),
            ],
          ),
        );
      },
    );

    if (isContent) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            searchField,
            Expanded(child: results),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            searchField,
            Expanded(child: results),
          ],
        ),
      ),
    );
  }
}

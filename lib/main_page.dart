import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/themes/theme.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/shop/presentation/pages/home_page.dart';
import 'features/shop/presentation/pages/search_page.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const SearchPageContent(),
    const CartPageContent(),
    const ChatPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Choose your skincare!',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
            ),
            SizedBox(height: 4),
            Text(
              'Hi, Rizky 💄',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
           Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
              child: CircleAvatar(
                backgroundColor: AppColors.surfaceWhite,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1518455027359-f3f816b1a22a?q=80&w=300&h=400&fit=crop',
                ),
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(icon: Icons.home_rounded, index: 0),
              _buildNavItem(icon: Icons.search_rounded, index: 1),
              _buildNavItem(icon: Icons.shopping_cart_outlined, index: 2, isCart: true),
              _buildNavItem(icon: Icons.chat_bubble_outline_rounded, index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index, bool isCart = false}) {
    final bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPink : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : AppColors.secondaryText,
              size: 24,
            ),
            if (isCart)
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state.items.isEmpty) return const SizedBox.shrink();
                  return Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : AppColors.primaryPink,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isActive ? AppColors.primaryPink : Colors.white, width: 1),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '${state.items.length}',
                        style: TextStyle(
                          color: isActive ? AppColors.primaryPink : Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const HomePage(isContent: true);
  }
}

class SearchPageContent extends StatelessWidget {
  const SearchPageContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const SearchPage(isContent: true);
  }
}

class CartPageContent extends StatelessWidget {
  const CartPageContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const CartPage(isContent: true);
  }
}

class ChatPlaceholder extends StatelessWidget {
  const ChatPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Chat',
        style: TextStyle(color: AppColors.primaryText),
      ),
    );
  }
}

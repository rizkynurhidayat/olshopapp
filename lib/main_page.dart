import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/core/themes/theme.dart';
import 'package:olshopapp/features/chat/presentation/pages/chat_page.dart';
import 'package:olshopapp/features/profile/presentation/pages/profile_page.dart';
import 'package:olshopapp/features/shop/presentation/pages/home_page.dart';
import 'package:olshopapp/features/shop/presentation/pages/search_page.dart';
import 'package:olshopapp/features/cart/presentation/pages/cart_page.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_state.dart';
import 'package:olshopapp/features/orders/presentation/bloc/order_bloc.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
    context.read<OrderBloc>().add(FetchOrders());
  }

  final List<Widget> _pages = [
    const HomePageContent(),
    const SearchPageContent(),
    const ChatPageContent(),
    const CartPageContent(),
    const ProfilePageContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            String name = 'User';
            if (state is Authenticated) {
              name = state.user.name;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose your skincare!',
                  style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hi, $name',
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
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
              _buildNavItem(icon: Icons.home_rounded, index: 0, label: 'Home'),
              _buildNavItem(
                  icon: Icons.search_rounded, index: 1, label: 'Search'),
              _buildNavItem(
                icon: Icons.chat_bubble_outline_rounded,
                index: 2,
                label: 'Chat',
                isChat: true,
              ),
              _buildNavItem(
                icon: Icons.shopping_cart_outlined,
                index: 3,
                label: 'Cart',
                isCart: true,
              ),
              _buildNavItem(
                icon: Icons.person_outline_rounded,
                index: 4,
                label: 'Profile',
                isProfile: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
    bool isCart = false,
    bool isChat = false,
    bool isProfile = false,
  }) {
    final bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (isChat) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatPage()),
          );
        } else if (isProfile) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(10),
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
                            color:
                                isActive ? Colors.white : AppColors.primaryPink,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.primaryPink
                                  : Colors.white,
                              width: 1,
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '${state.items.length}',
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.primaryPink
                                  : Colors.white,
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
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primaryPink : AppColors.secondaryText,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
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

class ChatPageContent extends StatelessWidget {
  const ChatPageContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const ChatPage(isContent: true);
  }
}

class CartPageContent extends StatelessWidget {
  const CartPageContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const CartPage(isContent: true);
  }
}

class ProfilePageContent extends StatelessWidget {
  const ProfilePageContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const ProfilePage(isContent: true);
  }
}

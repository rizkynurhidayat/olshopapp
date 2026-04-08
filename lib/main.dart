import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/injection_container.dart' as di;
import 'package:olshopapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:olshopapp/features/shop/presentation/bloc/shop_bloc.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:olshopapp/features/orders/presentation/bloc/order_bloc.dart';
import 'package:olshopapp/features/auth/presentation/pages/login_page.dart';
import 'package:olshopapp/features/auth/presentation/pages/splash_page.dart';
import 'package:olshopapp/main_page.dart';
import 'package:olshopapp/core/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()..add(AppStarted())),
        BlocProvider(create: (_) => di.sl<ShopBloc>()),
        BlocProvider(create: (_) => di.sl<CartBloc>()),
        BlocProvider(create: (_) => di.sl<OrderBloc>()),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Gemini Shop',
            theme: appTheme,
            home: _getHome(state),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  Widget _getHome(AuthState state) {
    if (state is AuthInitial || state is AuthLoading) {
      return const SplashPage();
    } else if (state is Authenticated) {
      return const MainPage();
    } else {
      return LoginPage();
    }
  }
}

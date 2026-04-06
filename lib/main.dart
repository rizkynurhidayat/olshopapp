import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/shop/presentation/bloc/shop_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'main_page.dart';
import 'core/themes/theme.dart';

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

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:olshopapp/core/storage/local_storage.dart';
import 'package:olshopapp/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:olshopapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:olshopapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:olshopapp/features/auth/domain/usecases/login.dart';
import 'package:olshopapp/features/auth/domain/usecases/logout.dart';
import 'package:olshopapp/features/auth/domain/usecases/register.dart';
import 'package:olshopapp/features/auth/domain/usecases/social_login.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:olshopapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:olshopapp/features/orders/data/datasources/order_local_data_source.dart';
import 'package:olshopapp/features/orders/data/repositories/order_repository_impl.dart';
import 'package:olshopapp/features/orders/domain/repositories/order_repository.dart';
import 'package:olshopapp/features/orders/domain/usecases/get_orders.dart';
import 'package:olshopapp/features/orders/domain/usecases/save_order.dart';
import 'package:olshopapp/features/orders/presentation/bloc/order_bloc.dart';
import 'package:olshopapp/features/shop/data/datasources/shop_remote_data_source.dart';
import 'package:olshopapp/features/shop/data/repositories/shop_repository_impl.dart';
import 'package:olshopapp/features/shop/domain/repositories/shop_repository.dart';
import 'package:olshopapp/features/shop/domain/usecases/get_product_detail.dart';
import 'package:olshopapp/features/shop/domain/usecases/get_products.dart';
import 'package:olshopapp/features/shop/domain/usecases/search_products.dart';
import 'package:olshopapp/features/shop/presentation/bloc/shop_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final localStorage = LocalStorage();
  await localStorage.init();
  sl.registerLazySingleton(() => localStorage);

  // Features - Auth
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        socialLoginUseCase: sl(),
        logoutUseCase: sl(),
        localStorage: sl(),
      ));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        firebaseAuth: sl(),
        googleSignIn: sl(),
      ));

  // Features - Shop
  sl.registerFactory(() => ShopBloc(getProducts: sl(), searchProducts: sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));
  sl.registerLazySingleton<ShopRepository>(() => ShopRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ShopRemoteDataSource>(() => ShopRemoteDataSourceImpl(dio: sl()));

  // Features - Cart
  sl.registerFactory(() => CartBloc(localStorage: sl()));

  // Features - Orders
  sl.registerFactory(() => OrderBloc(getOrders: sl(), saveOrder: sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => SaveOrder(sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<OrderLocalDataSource>(() => OrderLocalDataSourceImpl(localStorage: sl()));

  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'core/storage/local_storage.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/register.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/shop/data/datasources/shop_remote_data_source.dart';
import 'features/shop/data/repositories/shop_repository_impl.dart';
import 'features/shop/domain/repositories/shop_repository.dart';
import 'features/shop/domain/usecases/get_products.dart';
import 'features/shop/domain/usecases/search_products.dart';
import 'features/shop/presentation/bloc/shop_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final localStorage = LocalStorage();
  await localStorage.init();
  sl.registerLazySingleton(() => localStorage);

  // Features - Auth
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), registerUseCase: sl(), localStorage: sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // Features - Shop
  sl.registerFactory(() => ShopBloc(getProducts: sl(), searchProducts: sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton<ShopRepository>(() => ShopRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ShopRemoteDataSource>(() => MockShopRemoteDataSourceImpl());

  // Features - Cart
  sl.registerFactory(() => CartBloc(localStorage: sl()));

  // External
  sl.registerLazySingleton(() => Dio());
}

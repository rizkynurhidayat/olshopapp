import 'package:hive_flutter/hive_flutter.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/cart/domain/entities/cart_item.dart';
import '../../features/shop/domain/entities/product.dart';

class LocalStorage {
  static const String _userBoxName = 'userBox';
  static const String _cartBoxName = 'cartBox';
  static const String _sessionKey = 'session';

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ProductAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(CartItemAdapter());

    await Hive.openBox<User>(_userBoxName);
    await Hive.openBox<CartItem>(_cartBoxName);
  }

  // User Session
  Future<void> saveUser(User user) async {
    final box = Hive.box<User>(_userBoxName);
    await box.put(_sessionKey, user);
  }

  User? getUser() {
    final box = Hive.box<User>(_userBoxName);
    return box.get(_sessionKey);
  }

  Future<void> logout() async {
    final box = Hive.box<User>(_userBoxName);
    await box.delete(_sessionKey);
  }

  // Cart Data
  Future<void> saveCartItems(List<CartItem> items) async {
    final box = Hive.box<CartItem>(_cartBoxName);
    await box.clear();
    for (var item in items) {
      await box.add(item);
    }
  }

  List<CartItem> getCartItems() {
    final box = Hive.box<CartItem>(_cartBoxName);
    return box.values.toList();
  }

  Future<void> clearCart() async {
    final box = Hive.box<CartItem>(_cartBoxName);
    await box.clear();
  }
}

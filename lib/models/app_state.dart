import 'package:g_p/models/product.dart';
import 'package:meta/meta.dart';

import 'order.dart';

@immutable
class AppState {
  final dynamic user;
  final List<Product> products;
  final List<Product> carproducts;
  final List<Product> wedproducts;
  final List<Product> eleproducts;
  final List<Order> orders;
  final List<Product> htlproducts;
  final List<Product> lthproducts;
  final List<Product> cartProducts;
  final List<dynamic> cards;
  AppState({@required this.user,
    required this.products,
    required this.carproducts,
    required this.wedproducts,
    required this.eleproducts,
    required this.orders,
    required this.htlproducts,
    required this.lthproducts,
    required this.cartProducts,
    required this.cards});

  factory AppState.initial() {
    return AppState(
      user: null,
      products: [],
      orders: [],
      cartProducts: [],
      cards: [],
      carproducts: [],
      wedproducts: [],
      eleproducts: [],
      htlproducts: [],
      lthproducts: [],
    );
  }
}

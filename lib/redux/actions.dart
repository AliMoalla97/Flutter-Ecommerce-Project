import 'dart:convert';
import 'package:g_p/models/order.dart';
import 'package:g_p/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:g_p/models/app_state.dart';
import 'package:g_p/models/user.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* User Actions */
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String? storedUser = prefs.getString('user');
  final user = User.fromJson(json.decode(storedUser!));
  store.dispatch(GetUserAction(user));
};
ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User ? user ;
  store.dispatch(LogoutUserAction(user));
};



class GetUserAction {
  final User _user;

  User get user => this._user;

  GetUserAction(this._user);
}


class  LogoutUserAction {
  final User ? _user;

  User? get user => this._user;

  LogoutUserAction(this._user);
}

/* Products Actions */
ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  http.Response  response = await http.get(Uri.parse('http://172.19.250.153:1337/products'));
  List<dynamic> responseData = json.decode(response.body);
  List<Product> products = [];
  List<Product> newproducts = [];

  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    products.add(product);
  });
  newproducts = new List.from(products.reversed);
  store.dispatch(GetProductsAction(newproducts));

};


class GetProductsAction {
  final  List<dynamic> _products;

  List<dynamic> get products => this._products;

  GetProductsAction(this._products);
}


/* Cart Products Actions */
ThunkAction<AppState> toggleCartProductAction(Product cartProduct) {
  return (Store<AppState> store) async {
    final List<Product> cartProducts = store.state.cartProducts;
    final User user = store.state.user;
    final int index = cartProducts.indexWhere((product) => product.id == cartProduct.id);
    bool isInCart = index > -1 == true;
    List<Product> updatedCartProducts = List.from(cartProducts);
    if (isInCart) {
      updatedCartProducts.removeAt(index);
    } else {
      updatedCartProducts.add(cartProduct);
    }
    final List<String> cartProductsIds = updatedCartProducts.map((product) => product.id).toList();
    await http.put(Uri.parse('http://172.19.250.153:1337/carts/${user.cartId}'),
        body: {"products": json.encode(cartProductsIds)},
        headers: {"Authorization": "Bearer ${user.jwt}"});
    store.dispatch(ToggleCartProductAction(updatedCartProducts));
  };
}



ThunkAction<AppState> getCartProductsAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String? storedUser = prefs.getString('user');
  if (storedUser == null) {
    return;
  }
  final User user = User.fromJson(json.decode(storedUser));
  http.Response response = await http.get(Uri.parse('http://172.19.250.153:1337/carts/${user.cartId}'),
      headers: {'Authorization': 'Bearer ${user.jwt}'});
  final responseData = json.decode(response.body)['products'];
  List<Product> cartProducts = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    cartProducts.add(product);
 });
  store.dispatch(GetCartProductsAction(cartProducts));
};


ThunkAction<AppState> clearCartProductsAction = (Store<AppState> store) async {
  final User user = store.state.user;
  await http.put(Uri.parse('http://172.19.250.153:1337/carts/${user.cartId}'),
      body: {"products": json.encode([])},
      headers: {'Authorization': "Bearer ${user.jwt}"});
  store.dispatch(ClearCartProductsAction(List.empty()));
};



class ToggleCartProductAction {
  final List<Product> _cartProducts;

  List<Product> get cartProducts => this._cartProducts;

  ToggleCartProductAction(this._cartProducts);
}


class ClearCartProductsAction {
  final List<Product> _cartProducts;

  List<Product> get cartProducts => this._cartProducts;

  ClearCartProductsAction(this._cartProducts);
}

/* Cards Actions */
ThunkAction<AppState> getCardsAction = (Store<AppState> store) async {
  final String customerId = store.state.user.customerId;
  http.Response response = await http.get(Uri.parse('https://api.stripe.com/v1/customers/$customerId/sources'), headers: {'Authorization': 'Bearer sk_test_51K1nwrG38QROjSe4ChlV3AVlKbP6woRuikaw6xR3LGzhbKfpTm7yoDtVVAWh8vH0CZkQ5ov2Xza9IqWaBvcac0yV00g4R8SzYz'} );
  final responseData = json.decode(response.body);
   print('Card Data: $responseData\n\n\n\n\n');
  store.dispatch(GetCardsAction(responseData['data']));
};

class GetCardsAction {
  List<dynamic> _cards;

  List<dynamic> get cards => this._cards;

  GetCardsAction(this._cards);
}



class GetCartProductsAction {
  final List<Product> _cartProducts;

  List<Product> get cartProducts => this._cartProducts;

  GetCartProductsAction(this._cartProducts);
}

/* WedProducts Actions */
ThunkAction<AppState> getWedProductsAction = (Store<AppState> store) async {
  http.Response  responsewed = await http.get(Uri.parse('http://172.19.250.153:1337/products'));
  List<dynamic> responseDatawed = json.decode(responsewed.body);
  List<Product> Wedproducts = [];
  responseDatawed.forEach((productData) {
    if(productData["Tag"]=="wedding"){
      final Product wedproduct = Product.fromJson(productData);
      Wedproducts.add(wedproduct);
    }
  });List<Product> newproducts = [];
  newproducts = new List.from(Wedproducts.reversed);
  store.dispatch(GetWedProductsAction(newproducts));
};



class GetWedProductsAction {
  final  List<Product> _wedproducts;

  List<Product> get wedproducts => this._wedproducts;

  GetWedProductsAction(this._wedproducts);
}

/* EleProducts Actions */
ThunkAction<AppState> getEleProductsAction = (Store<AppState> store) async {
  http.Response  responseele = await http.get(Uri.parse('http://172.19.250.153:1337/products'));
  List<dynamic> responseDataele = json.decode(responseele.body);
  List<Product> Eleproducts = [];
  responseDataele.forEach((productData) {
    if(productData["Tag"]=="electric"){
      final Product eleproduct = Product.fromJson(productData);
      Eleproducts.add(eleproduct);
    }
  });  List<Product> newproducts = [];
  newproducts = new List.from(Eleproducts.reversed);
  store.dispatch(GetEleProductsAction(newproducts));
};



class GetEleProductsAction {
  final  List<Product> _eleproducts;

  List<Product> get eleproducts => this._eleproducts;

  GetEleProductsAction(this._eleproducts);
}

/* CarProducts Actions */
ThunkAction<AppState> getCarProductsAction = (Store<AppState> store) async {
  http.Response  responsecar = await http.get(Uri.parse('http://172.19.250.153:1337/products'));
  List<dynamic> responseDatacar = json.decode(responsecar.body);
  List<Product> Carproducts = [];
  responseDatacar.forEach((productData) {
    if(productData["Tag"]=="car"){
      final Product carproduct = Product.fromJson(productData);
      Carproducts.add(carproduct);
    }
  });
  List<Product> newproducts = [];
  newproducts = new List.from(Carproducts.reversed);
  store.dispatch(GetCarProductsAction(newproducts));
};



class GetCarProductsAction {
  final  List<Product> _carproducts;

  List<Product> get carproducts => this._carproducts;

  GetCarProductsAction(this._carproducts);
}

/* low to high price Products Actions */
ThunkAction<AppState> getLthProductsAction = (Store<AppState> store) async {
  http.Response  responselth = await http.get(Uri.parse('http://172.19.250.153:1337/products'));
  List<dynamic> responseDatalth = json.decode(responselth.body);
  List<Product> Lthproducts = [];
  responseDatalth.forEach((productData) {
      final Product lthproduct = Product.fromJson(productData);
      Lthproducts.add(lthproduct);
  });
  Lthproducts.sort((a, b) => a.price.compareTo(b.price));
  store.dispatch(GetLthProductsAction(Lthproducts));
};



class GetLthProductsAction {
  final  List<Product> _lthproducts;

  List<Product> get lthproducts => this._lthproducts;

  GetLthProductsAction(this._lthproducts);
}

/* high to low price Products Actions */
ThunkAction<AppState> getHtlProductsAction = (Store<AppState> store) async {
  http.Response  responsehtl = await http.get(Uri.parse('http://172.19.250.153:1337/products'));
  List<dynamic> responseDatahtl = json.decode(responsehtl.body);
  List<Product> Htlproducts = [];
  responseDatahtl.forEach((productData) {
    final Product htlproduct = Product.fromJson(productData);
   Htlproducts.add(htlproduct);
  });
  Htlproducts.sort((a, b) => a.price.compareTo(b.price,));
  List<Product> reversedList = new List.from(Htlproducts.reversed);
  store.dispatch(GetHtlProductsAction(reversedList));
};



class GetHtlProductsAction {
  final  List<Product> _htlproducts;

  List<Product> get htlproducts => this._htlproducts;

  GetHtlProductsAction(this._htlproducts);
}

/* Orders Actions */

ThunkAction<AppState> getOrderAction = (Store<AppState> store) async {
  final String jwt = store.state.user.jwt;
  http.Response response = await http.get(Uri.parse('http://172.19.250.153:1337/users/${store.state.user}/orders'),
      headers: {'Authorization': 'Bearer $jwt'});
  final responseData = json.decode(response.body);
  List<Order> orders = [];
  responseData['orders'].forEach((orderData) {
    final Order order = Order.fromJson(orderData);
    orders.add(order);
  });
  store.dispatch(GetOrdersAction(orders));
};


class AddOrderAction {
  final Order _order;

  Order get order => this._order;

  AddOrderAction(this._order);
}
class GetOrdersAction {
  final List<Order> _orders;

  List<Order> get orders => this._orders;

  GetOrdersAction(this._orders);
}

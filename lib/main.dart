import 'package:g_p/pages/add_card_page.dart';
import 'package:g_p/pages/comment_page.dart';
import 'package:flutter/material.dart';
import 'package:g_p/models/app_state.dart';
import 'package:g_p/pages/cart_page.dart';
import 'package:g_p/pages/porfile_page.dart';
import 'package:g_p/redux/actions.dart';
import 'package:g_p/redux/reducers.dart';
import 'package:g_p/pages/login_page.dart';
import 'package:g_p/pages/products_page.dart';
import 'package:g_p/pages/register_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';


void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
        title: 'Creative Designs',
        routes: {
        '/': (BuildContext context) => ProductsPage(onInit: () {
        StoreProvider.of<AppState>(context).dispatch(getUserAction);
        StoreProvider.of<AppState>(context).dispatch(getProductsAction);
        StoreProvider.of<AppState>(context).dispatch(getEleProductsAction);
        StoreProvider.of<AppState>(context).dispatch(getWedProductsAction);
        StoreProvider.of<AppState>(context).dispatch(getCarProductsAction);
        StoreProvider.of<AppState>(context).dispatch(getLthProductsAction);
        StoreProvider.of<AppState>(context).dispatch(getHtlProductsAction);
        StoreProvider.of<AppState>(context).dispatch(getCartProductsAction);
        }),

        '/login': (BuildContext context) => LoginPage(),
         '/addcard': (BuildContext context) => Addcard(),
          '/register': (BuildContext context) => RegisterPage(),
          '/profile': (BuildContext context) => SettingsUI(),
          '/reviews': (BuildContext context) => TestMe(),
          '/cart': (BuildContext context) => CartPage(onInit: () {
        StoreProvider.of<AppState>(context).dispatch(getCardsAction);
        StoreProvider.of<AppState>(context).dispatch(getOrderAction);
        })
        },
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.cyan[400],
          //  accentColor: Colors.deepOrange[200],
            textTheme: const TextTheme(
                headline1:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold,color: Colors.white),
                subtitle1: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
                bodyText1: TextStyle(fontSize: 25.0))),
        ));
  }
}

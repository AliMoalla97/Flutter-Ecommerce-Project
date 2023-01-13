import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:g_p/models/app_state.dart';
import 'package:g_p/models/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:g_p/pages/products_page.dart';
import 'package:g_p/redux/actions.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';
class ProductDetailPage extends StatelessWidget {
  final Product item;
  final _formKey = GlobalKey<FormState>();
  late String _ptext;

  ProductDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://172.19.250.153:1337${item.picture['url']}';
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    return Scaffold(
        appBar: AppBar(title: Text(item.name)),
        body: Container(
            decoration: gradientBackground,
            child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Hero(
                        tag: item,
                        child: Image.network(pictureUrl,
                            width: orientation == Orientation.portrait
                                ? 600
                                : 250,
                            height: orientation == Orientation.portrait
                                ? 400
                                : 200,
                            fit: BoxFit.cover)),
                  ),
                  Text(item.name, style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1),
                  Text('₪${item.price}', style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1),
                  Column(children: [
                    Padding(
                        child: Text(item.description),
                        padding: EdgeInsets.only(
                            left: 32.0, right: 32.0, bottom: 15.0)),

                    Form(
                        key: _formKey,
                       child: Padding(
                            padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 10.0),
                            child: TextFormField(
                                onSaved: (val) => _ptext = val!,
                                validator: (val) => val== "" ? 'الرجاء ادخال نص' : null,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'النص',
                                    hintText: 'ادخل النص الذي تريد كتابته على المنتج',
                                    icon: Icon(Icons.input, color: Colors.white)))),
                        ),

                    Padding(padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, bottom: 30.0),
                        child: StoreConnector<AppState, AppState>(
                            converter: (store) => store.state,
                            builder: (_, state) {
                              return state.user != null
                                  ? Badge(
                                showBadge: state.cartProducts.length==0? false : true,
                                badgeColor:Colors.limeAccent,
                                badgeContent: Text(state.cartProducts.length.toString(), style: TextStyle(color: Colors.black)),
                                  child :IconButton( icon: Icon(Icons.shopping_cart,size: 45),
                                  color: _isInCart(state, item.id)
                                      ? Colors.tealAccent
                                      : Colors.teal,

                                  onPressed: ()async{
                                    await _submit();
                                    if(_submit()){
                                      _PText(state);
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(toggleCartProductAction(item));
                                    Fluttertoast.showToast(
                                        msg:'Cart Updated!',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0

                                    );
                                  }}
                              ))
                                  : Text('');
                            })),
                    Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 10.0),
                        child : TextButton(
                            child:  Text("Reviews",style: new TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ), ),

                            style: TextButton.styleFrom(
                              primary: Colors.teal,

                            ), onPressed: () =>  Navigator.pushNamed(context, '/reviews'))
                    ),
                  ])
                ]))));
  }



  bool _isInCart(AppState state, String id) {
    final List<Product> cartProducts = state.cartProducts;
    return cartProducts.indexWhere((cartProduct) => cartProduct.id == id) > -1;
  }


  void _PText(AppState state) async {
    http.Response response = await http.put(
        Uri.parse('http://172.19.250.153:1337/products/${item.id}'), body: {
      "ptext": _ptext,
    });}

    bool _submit() {
      final form = _formKey.currentState;

      if (form!.validate()) {
        form.save();

         return true;
      }
      return false;
    }

}

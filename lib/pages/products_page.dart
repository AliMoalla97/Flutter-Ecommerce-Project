import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:g_p/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:g_p/redux/actions.dart';
import 'package:g_p/widgets/product_item.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
final gradientBackground = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: [
          0.1,
          0.3,
          0.5,
          0.7,
          0.9
        ], colors: [Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12

    ],
       ));

class ProductsPage extends StatefulWidget {
  final void Function() onInit;
  ProductsPage({required this.onInit});

  @override
  ProductsPageState createState() => ProductsPageState();
}

class ProductsPageState extends State<ProductsPage> {
  void initState() {
    super.initState();
    widget.onInit();
  }

  final _appBar = PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return AppBar(

                centerTitle: true,
                title: SizedBox(

                    child: state.user != null
                        ? TextButton(
                        child:  Text(state.user.username,style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ), ),

                        style: TextButton.styleFrom(
                          primary: Colors.white,

                        ), onPressed: () =>  Navigator.pushNamed(context, '/profile'))
                : TextButton(
                        child: Text('Register Here',
                            style: new TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                        style: TextButton.styleFrom(primary: Colors.white,),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'))),

                leadingWidth: 120,
                leading:Row(children:[

                Padding(padding: EdgeInsets.only(right:12),
                   child: state.user != null
                       ? IconButton(
                        icon: Icon(Icons.chat),
                           onPressed: () async {
                             try {
                               dynamic user = {
                                 'userId' : state.user.id,   //Replace it with the userId of the logged in user
                                 'password' : "" //Put password here if user has password, ignore otherwise
                               };
                               dynamic conversationObject = {
                                 'isSingleConversation': false,
                                 'appId': '3fb058bb604c5f0b68266335ef664abf0',// The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
                                 'kmUser': jsonEncode(user)
                               };
                               dynamic result = await KommunicateFlutterPlugin.buildConversation(conversationObject);

                               print("Conversation builder success : " + result.toString());
                             } on Exception catch (e) {
                               print("Conversation builder error occurred : " + e.toString());
                             }
                           })
                               : Text('')),

                  Padding(padding: EdgeInsets.only(right:12),
                      child: state.user != null
                          ? Badge(
                          showBadge: state.cartProducts.length==0? false : true,
                          badgeColor:Colors.limeAccent,
                          badgeContent: Text(state.cartProducts.length.toString(), style: TextStyle(color: Colors.black)),
                          position: BadgePosition.topEnd(top: -1, end: 1),
                          child:IconButton(
                          icon: Icon(Icons.store),
                          onPressed: () =>  Navigator.pushNamed(context, '/cart')))
                          : Text('')),


                ]),

            actions: [

              Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: StoreConnector<AppState, VoidCallback>(
                      converter: (store) {
                        return () => store.dispatch(logoutUserAction);
                      }, builder: (_, callback) {
                    return state.user != null
                        ? IconButton(
                        icon: Icon(Icons.local_shipping),
                        onPressed: () => print('pressed local_shipping'))
                        : Text('');
                  })),
                  Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: StoreConnector<AppState, VoidCallback>(
                          converter: (store) {
                            return () => store.dispatch(logoutUserAction);
                          }, builder: (_, callback) {
                        return state.user != null
                            ? IconButton(
                            icon: Icon(Icons.exit_to_app),
                            onPressed: callback)
                            : Text('');
                      })),

                ]);
          }));
  Widget _homeTab() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(

     //   appBar: ,
        appBar: AppBar(
            title:Text("HomePage"),
          bottom: TabBar(

            isScrollable: true,
          labelColor: Colors.tealAccent,
          unselectedLabelColor: Colors.teal,
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.electrical_services )),
            Tab(icon: Icon(Icons.person)),
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.arrow_circle_up_rounded)),
            Tab(icon: Icon(Icons.arrow_circle_down_rounded)),
          ],
        )
        ),
        body: Container(

            decoration: gradientBackground,
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return Column(children: [
                    Expanded(
                        child: SafeArea(
                            top: false,
                            bottom: false,
                            child: GridView.builder(
                                itemCount: state.products.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                    orientation == Orientation.portrait ? 2 : 3,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    childAspectRatio:
                                    orientation == Orientation.portrait ? 1.0 : 1.3),
                                itemBuilder: (context, i) =>
                                    ProductItem(item: state.products[i]))))
                  ]);
                })));
  }
  Widget _electricTab() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      //   appBar: ,
        appBar: AppBar(
            title:Text("Electric Decorations"),
            bottom: TabBar(       isScrollable: true,
              labelColor: Colors.tealAccent,
              unselectedLabelColor: Colors.teal,
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.electrical_services )),
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.arrow_circle_up_rounded)),
                Tab(icon: Icon(Icons.arrow_circle_down_rounded)),
              ],
            )
        ),
        body: Container(
            decoration: gradientBackground,
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return Column(children: [
                    Expanded(
                        child: SafeArea(
                            top: false,
                            bottom: false,
                            child: GridView.builder(
                                itemCount: state.eleproducts.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                    orientation == Orientation.portrait ? 2 : 3,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    childAspectRatio:
                                    orientation == Orientation.portrait ? 1.0 : 1.3),
                                itemBuilder: (context, i) =>
                                    ProductItem(item: state.eleproducts[i]))))
                  ]);
                })));
  }
  Widget _weddingTab() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      //   appBar: ,
        appBar: AppBar(
            title:Text("Weddings Decorations"),
            bottom: TabBar(       isScrollable: true,
              labelColor: Colors.tealAccent,
              unselectedLabelColor: Colors.teal,
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.electrical_services )),
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.arrow_circle_up_rounded)),
                Tab(icon: Icon(Icons.arrow_circle_down_rounded)),
              ],
            )
        ),
        body: Container(
            decoration: gradientBackground,
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return Column(children: [
                    Expanded(
                        child: SafeArea(
                            top: false,
                            bottom: false,
                            child: GridView.builder(
                                itemCount: state.wedproducts.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                    orientation == Orientation.portrait ? 2 : 3,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    childAspectRatio:
                                    orientation == Orientation.portrait ? 1.0 : 1.3),
                                itemBuilder: (context, i) =>
                                    ProductItem(item: state.wedproducts[i]))))
                  ]);
                })));
  }
  Widget _carTap() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      //   appBar: ,
        appBar: AppBar(
            title:Text("Car Decorations"),
            bottom: TabBar(       isScrollable: true,
              labelColor: Colors.tealAccent,
              unselectedLabelColor: Colors.teal,
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.electrical_services )),
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.arrow_circle_up_rounded)),
                Tab(icon: Icon(Icons.arrow_circle_down_rounded)),
              ],
            )
        ),
        body: Container(
            decoration: gradientBackground,
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return Column(children: [
                    Expanded(
                        child: SafeArea(
                            top: false,
                            bottom: false,
                            child: GridView.builder(
                                itemCount: state.carproducts.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                    orientation == Orientation.portrait ? 2 : 3,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    childAspectRatio:
                                    orientation == Orientation.portrait ? 1.0 : 1.3),
                                itemBuilder: (context, i) =>
                                    ProductItem(item: state.carproducts[i]))))
                  ]);
                })));
  }
  Widget _htolTab() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      //   appBar: ,
        appBar: AppBar(
            title:Text("HightoLow Price"),
            bottom: TabBar(
              isScrollable: true,
              labelColor: Colors.tealAccent,
              unselectedLabelColor: Colors.teal,
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.electrical_services )),
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.arrow_circle_up_rounded)),
                Tab(icon: Icon(Icons.arrow_circle_down_rounded)),
              ],
            )
        ),
        body: Container(
            decoration: gradientBackground,
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return Column(children: [
                    Expanded(
                        child: SafeArea(
                            top: false,
                            bottom: false,
                            child: GridView.builder(
                                itemCount: state.htlproducts.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                    orientation == Orientation.portrait ? 2 : 3,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    childAspectRatio:
                                    orientation == Orientation.portrait ? 1.0 : 1.3),
                                itemBuilder: (context, i) =>
                                    ProductItem(item: state.htlproducts[i]))))
                  ]);
                })));
  }

  Widget _ltohTab() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      //   appBar: ,
        appBar: AppBar(
            title:Text("LowToHigh price"),
            bottom: TabBar( isScrollable: true,
              labelColor: Colors.tealAccent,
              unselectedLabelColor: Colors.teal,
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.electrical_services )),
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.arrow_circle_up_rounded)),
                Tab(icon: Icon(Icons.arrow_circle_down_rounded)),
              ],
            )
        ),
        body: Container(
            decoration: gradientBackground,
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  return Column(children: [
                    Expanded(
                        child: SafeArea(
                            top: false,
                            bottom: false,
                            child: GridView.builder(
                                itemCount: state.lthproducts.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                    orientation == Orientation.portrait ? 2 : 3,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    childAspectRatio:
                                    orientation == Orientation.portrait ? 1.0 : 1.3),
                                itemBuilder: (context, i) =>
                                    ProductItem(item: state.lthproducts[i]))))
                  ]);
                })));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        initialIndex: 0,
        child: Scaffold(
            appBar:_appBar,

            body:TabBarView(children: [_homeTab(),_electricTab(), _weddingTab(),_carTap(),_htolTab(),_ltohTab()])));
  }
}




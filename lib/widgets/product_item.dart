import 'package:flutter/material.dart';
import 'package:g_p/models/app_state.dart';
import 'package:g_p/models/product.dart';
import 'package:g_p/pages/product_detail_page.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductItem extends StatelessWidget {
  final Product item;
  ProductItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://172.19.250.153:1337${item.picture['url']}';
    return InkWell(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProductDetailPage(item: item);
            })),
        child: GridTile(
            footer: GridTileBar(
                title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(item.name, style: TextStyle(fontSize: 20.0))),
                subtitle:
                Text("₪${item.price}", style: TextStyle(fontSize: 16.0)),
                backgroundColor: Color(0xBB000000),
                ),
            child: Hero(
                tag: item,
                child: Image.network(pictureUrl, fit: BoxFit.cover))));
  }
}
class EleProductItem extends StatelessWidget {
  final Product item;
  EleProductItem({required this.item});
  @override
  Widget build(BuildContext context) {
    if (item.Tag=="electric") {
    final String pictureUrl = 'http://172.19.250.153:1337${item.picture['url']}';
    return InkWell(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProductDetailPage(item: item);
            })),
        child: GridTile(
            footer: GridTileBar(
              title: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(item.name, style: TextStyle(fontSize: 20.0))),
              subtitle:
              Text("₪${item.price}", style: TextStyle(fontSize: 16.0)),
              backgroundColor: Color(0xBB000000),
            ),
            child: Hero(
                tag: item,
                child: Image.network(pictureUrl, fit: BoxFit.cover))));}
    else return new Container();
  }
}
class WedProductItem extends StatelessWidget {
  final Product item;
  WedProductItem({required this.item});
  @override
  Widget build(BuildContext context) {
    if (item.Tag=="wedding") {
      final String pictureUrl = 'http://172.19.250.153:1337${item.picture['url']}';
      return InkWell(
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProductDetailPage(item: item);
              })),
          child: GridTile(
              footer: GridTileBar(
                title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(item.name, style: TextStyle(fontSize: 20.0))),
                subtitle:
                Text("₪${item.price}", style: TextStyle(fontSize: 16.0)),
                backgroundColor: Color(0xBB000000),
              ),
              child: Hero(
                  tag: item,
                  child: Image.network(pictureUrl, fit: BoxFit.cover))));}
    else {
      return Container() ;
    }
  }
}
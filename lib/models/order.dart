import 'package:meta/meta.dart';

class Order {
  final int? amount;
  final String? createdAt;
  final List<dynamic>? products;


  Order(
      {@required this.amount,
        @required this.createdAt,
        @required this.products});

  factory Order.fromJson(json) {
    return Order(
        amount: json['amount'],
        createdAt: json['createdAt'],
        products: json['products']);
  }
}

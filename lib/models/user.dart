import 'package:meta/meta.dart';

class User {
  String ?id;
  String ?username;
  String ?email;
  String ?jwt;
  String ?cartId;
  String ?address;
  String ?phone;
  String ?customerId;
  String img;

  User(
      { @required this.id,
        @required this.username,
        @required this.email,
        @required this.jwt,
        @required this.cartId,
        @required this.address,
        @required this.phone,
        @required this.customerId,
        required this.img
      });

  factory User.fromJson(Map<String,dynamic> json) {
    return User(
        id: json['_id'],
        username: json['username'],
        email: json['email'],
        jwt: json['jwt'],
        cartId: json['cart_id'],
        address: json['address'],
        phone: json['phone'],
        customerId: json['customer_id'],
        img: json['img'],
    );
  }
}

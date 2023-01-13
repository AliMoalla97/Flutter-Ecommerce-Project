import 'package:meta/meta.dart';

class Product {
  String id;
  String name;
  String description;
  String Tag;
  String ? ptext;
  num price;
  Map<String, dynamic> picture;

  Product(
      { required this.id,
        required this.name,
        required this.Tag,
         this.ptext,
        required this.description,
        required this.price,
        required this.picture});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "ptext":ptext,
      "description": description,
      "price": price,
      "picture": picture
    };
  }


    factory Product.fromJson( json) {
    return Product(
        id: json['id'],
        Tag: json['Tag'],
        ptext: json['ptext'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        picture: json['picture'][0]);
  }
}

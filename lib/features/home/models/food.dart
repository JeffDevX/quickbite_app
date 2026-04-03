// To parse this JSON data, do
//
//     final foodModel = foodModelFromJson(jsonString);

import 'dart:convert';

List<Food> foodModelFromJson(String str) =>
    List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

String foodModelToJson(List<Food> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
  bool available;
  Category category;
  String name;
  String pictureUrl;
  double price;
  int stock;
  String description;
  String? type;
  List<Item>? items;

  Food({
    required this.available,
    required this.category,
    required this.name,
    required this.pictureUrl,
    required this.price,
    required this.stock,
    required this.description,
    this.type,
    this.items,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    available: json["available"],
    category: categoryValues.map[json["category"]]!,
    name: json["name"],
    pictureUrl: json["pictureUrl"],
    price: json["price"]?.toDouble(),
    stock: json["stock"],
    description: json["description"],
    type: json["type"],
    items:
        json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "available": available,
    "category": categoryValues.reverse[category],
    "name": name,
    "pictureUrl": pictureUrl,
    "price": price,
    "stock": stock,
    "description": description,
    "type": type,
    "items":
        items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

enum Category {
  bebidas("Bebidas"),
  combos("Combos"),
  hamburguesas("Hamburguesas"),
  pizzas("Pizzas");

  final String name;
  const Category(this.name);
}

final categoryValues = EnumValues({
  "Bebidas": Category.bebidas,
  "Combos": Category.combos,
  "Hamburguesas": Category.hamburguesas,
  "Pizzas": Category.pizzas,
});

class Item {
  String productName;
  int quantity;

  Item({required this.productName, required this.quantity});

  factory Item.fromJson(Map<String, dynamic> json) =>
      Item(productName: json["productName"], quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "quantity": quantity,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

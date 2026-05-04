import 'dart:convert';
import 'package:equatable/equatable.dart';

// Funciones de ayuda para JSON
List<Food> foodModelFromJson(String str) =>
    List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

String foodModelToJson(List<Food> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food extends Equatable {
  final bool available;
  final Category category;
  final String name;
  final String pictureUrl;
  final double price;
  final int stock;
  final String description;
  final String? type;
  final List<Item>? items;

  const Food({
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

  factory Food.fromJson(Map<dynamic, dynamic> json) {
    // Limpiamos el mapa principal
    final data = Map<String, dynamic>.from(json);

    return Food(
      available: data["available"] ?? false,
      category: categoryValues.map[data["category"]] ?? Category.combos,
      name: data["name"] ?? '',
      pictureUrl: data["pictureUrl"] ?? '',
      price: (data["price"] ?? 0).toDouble(),
      stock: data["stock"] ?? 0,
      description: data["description"] ?? '',
      type: data["type"],
      items:
          data["items"] == null
              ? []
              : (data["items"] as List)
                  .map((x) => Item.fromJson(x as Map))
                  .toList(),
    );
  }

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

  // Esto permite que el Bloc compare si dos objetos Food son iguales por su contenido
  @override
  List<Object?> get props => [
    available,
    category,
    name,
    pictureUrl,
    price,
    stock,
    description,
    type,
    items,
  ];
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

class Item extends Equatable {
  final String productName;
  final int quantity;

  const Item({required this.productName, required this.quantity});

  factory Item.fromJson(Map<dynamic, dynamic> json) {
    // Convertimos a Map<String, dynamic> internamente
    final data = Map<String, dynamic>.from(json);
    return Item(
      productName: data["productName"] ?? '',
      quantity: data["quantity"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "quantity": quantity,
  };

  @override
  List<Object?> get props => [productName, quantity];
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

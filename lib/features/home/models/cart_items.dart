import 'package:equatable/equatable.dart';
import 'package:quickbite_app/features/home/models/food.dart';

class CartItems extends Equatable {
  final Food food;
  final int quantity;

  const CartItems({required this.food, required this.quantity});

  double get totalPrice => food.price * quantity;

  @override
  List<Object?> get props => [food, quantity]; // <--- ESTO ES LO QUE FALTA
}

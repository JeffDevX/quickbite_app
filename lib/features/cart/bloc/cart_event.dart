part of 'cart_bloc.dart';

sealed class CartEvent {}

class AddToCart extends CartEvent {
  final Food food;

  AddToCart(this.food);
}

class RemoveFromCart extends CartEvent {
  final Food food;

  RemoveFromCart(this.food);
}

class IncrementQuantity extends CartEvent {
  final Food food;

  IncrementQuantity(this.food);
}

class DecrementQuantity extends CartEvent {
  final Food food;

  DecrementQuantity(this.food);
}

class CheckoutRequested extends CartEvent {}

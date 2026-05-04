import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quickbite_app/features/home/models/cart_items.dart';

@immutable
sealed class CartState extends Equatable {
  final List<CartItems> items;
  final double total;

  const CartState({required this.items, required this.total});

  // Esto es lo que permite que el Bloc sepa que el estado CAMBIÓ
  // aunque la clase sea la misma (CartLoaded)
  @override
  List<Object?> get props => [items, total];
}

// 1. Estado inicial: Carrito vacío
final class CartInitial extends CartState {
  const CartInitial() : super(items: const [], total: 0);
}

// 2. Estado de carga: Mientras se procesa el pago en Firebase
final class CartLoading extends CartState {
  const CartLoading({required super.items, required super.total});

  @override
  List<Object?> get props => [items, total];
}

// 3. Estado cargado: Es el que usas para añadir/quitar productos
final class CartLoaded extends CartState {
  const CartLoaded({required super.items, required super.total});

  @override
  List<Object?> get props => [items, total];
}

// 4. Estado de éxito: Cuando el pago en Firestore fue correcto
final class CartSuccess extends CartState {
  final String orderId;

  // Al tener éxito, el carrito se limpia (items vacíos, total 0)
  const CartSuccess({required this.orderId}) : super(items: const [], total: 0);

  @override
  List<Object?> get props => [orderId, items, total];
}

// 5. Estado de error: Si algo falla al conectar con Firebase
final class CartError extends CartState {
  final String message;

  const CartError({
    required this.message,
    required super.items,
    required super.total,
  });

  @override
  List<Object?> get props => [message, items, total];
}

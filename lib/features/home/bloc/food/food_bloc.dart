import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:quickbite_app/features/home/models/food_models.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final List<Food> _allFood = [
    // --- HAMBURGUESAS ---
    Food(
      name: 'Classic Burger',
      category: 'Hamburguesas',
      price: 12.99,
      image: 'assets/images/classicburguer.jpeg',
    ),
    Food(
      name: 'Double Cheese Bacon',
      category: 'Hamburguesas',
      price: 14.99,
      image: 'assets/images/double_bacon.jpeg',
    ),
    Food(
      name: 'Bacon Cheese Burger',
      category: 'Hamburguesas',
      price: 12.99,
      image: 'assets/images/bacon_cheese.jpeg',
    ),

    // --- PIZZAS ---
    Food(
      name: 'Pepperoni Fiesta',
      category: 'Pizzas',
      price: 15.99,
      image: 'assets/pepperoni.png',
    ),
    Food(
      name: 'Hawaiana Special',
      category: 'Pizzas',
      price: 13.50,
      image: 'assets/hawaiana.png',
    ),
    Food(
      name: 'Margarita Classic',
      category: 'Pizzas',
      price: 12.00,
      image: 'assets/margarita.png',
    ),

    // --- BEBIDAS ---
    Food(
      name: 'Coca Cola 500ml',
      category: 'Bebidas',
      price: 2.50,
      image: 'assets/coke.png',
    ),
    Food(
      name: 'Jugo Natural',
      category: 'Bebidas',
      price: 3.50,
      image: 'assets/juice.png',
    ),
  ];

  FoodBloc() : super(FoodInitial()) {
    //Inicia la app
    on<FoodStarted>((event, emit) async {
      emit(FoodLoading());

      await Future.delayed(Duration(seconds: 2));

      final initialList =
          _allFood.where((x) => x.category == 'Hamburguesas').toList();

      emit(FoodLoaded(foods: initialList, selectedCategory: 'Hamburguesas'));
    });

    //Filtrar categoria de comida
    on<FoodCategorySelected>(_onChangedCategory);
  }

  Future<void> _onChangedCategory(
    FoodCategorySelected event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    await Future.delayed(Duration(seconds: 2));

    final filteredList =
        _allFood.where((x) => x.category == event.category).toList();

    emit(FoodLoaded(foods: filteredList, selectedCategory: event.category));
  }
}

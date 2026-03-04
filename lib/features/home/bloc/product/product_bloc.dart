import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:quickbite_app/features/home/models/food_model.dart';
import 'package:quickbite_app/features/home/repository/products_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProducState> {
  final ProductsRepository repository;
  StreamSubscription? _subscription;

  ProductBloc(this.repository) : super(ProducInitial()) {
    //Inicia la app
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());

      await emit.forEach<List<FoodModel>>(
        repository.getProducts(),
        onData: (products) {
          final selectedCategory =
              state is ProductLoaded
                  ? (state as ProductLoaded).selectedCategory
                  : Category.combos;

          final filteredProducts =
              products.where((e) => e.category == selectedCategory).toList();

          return ProductLoaded(
            allProducts: products,
            filteredProducts: filteredProducts,
            selectedCategory: selectedCategory,
          );
        },
        onError:
            (_, __) => ProductError(errorMessage: "Error loading products"),
      );
    });

    on<ChangeCategory>((event, emit) {
      final currentState = state as ProductLoaded;

      final filteredProducts =
          currentState.allProducts
              .where((e) => e.category == event.category)
              .toList();

      emit(
        ProductLoaded(
          allProducts: currentState.allProducts,
          filteredProducts: filteredProducts,
          selectedCategory: event.category,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription
        ?.cancel(); // Importante cerrar la suscripción al destruir el BLoC
    return super.close();
  }
}

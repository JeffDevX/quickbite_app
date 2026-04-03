import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:quickbite_app/features/home/models/food.dart';
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

      await emit.forEach<List<Food>>(
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
        onError: (error, stackTrace) {
          print('Firestore error: $error'); // Debug log
          print('Stack trace: $stackTrace'); // Debug log

          String errorMessage = "Error loading products";

          // Handle specific Firebase errors
          if (error.toString().contains('permission-denied')) {
            errorMessage =
                "Permission denied. Please check your authentication.";
          } else if (error.toString().contains('unavailable')) {
            errorMessage =
                "Service unavailable. Please check your internet connection.";
          } else if (error.toString().contains('not-found')) {
            errorMessage = "Products collection not found.";
          } else {
            errorMessage = "Error loading products: ${error.toString()}";
          }

          return ProductError(errorMessage: errorMessage);
        },
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

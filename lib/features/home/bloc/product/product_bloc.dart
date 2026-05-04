import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:quickbite_app/features/home/models/food.dart';
import 'package:quickbite_app/features/home/repository/products_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProducState> {
  final ProductsRepository repository;

  ProductBloc(this.repository) : super(ProducInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());

      try {
        // Llamada al microservicio a través del repositorio
        final catalog = await repository.getCatalog();

        final List<Food> allProducts = catalog['products'];
        // Aquí podrías guardar también las categorías si tu estado lo permite
        // final List<dynamic> categories = catalog['categories'];

        // Determinar categoría inicial
        const initialCategory = Category.combos;

        final filteredProducts =
            allProducts.where((e) => e.category == initialCategory).toList();

        emit(
          ProductLoaded(
            allProducts: allProducts,
            filteredProducts: filteredProducts,
            selectedCategory: initialCategory,
          ),
        );
      } catch (e) {
        print('Error en microservicio: $e');
        emit(ProductError(errorMessage: e.toString()));
      }
    });

    on<ChangeCategory>((event, emit) {
      // Usamos un "if is" para asegurar que tenemos datos cargados
      if (state is ProductLoaded) {
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
      }
    });
  }

  // Ya no necesitamos sobreescribir close() para cancelar la suscripción
  // porque los Futures se cierran solos al terminar la petición.
}

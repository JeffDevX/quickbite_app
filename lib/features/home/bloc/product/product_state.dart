part of 'product_bloc.dart';

@immutable
sealed class ProducState {}

final class ProducInitial extends ProducState {}

final class ProductLoading extends ProducState {}

class ProductLoaded extends ProducState {
  final List<Food> allProducts;
  final List<Food> filteredProducts;
  final Category selectedCategory;

  ProductLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.selectedCategory,
  });
}

final class ProductError extends ProducState {
  final String errorMessage;

  ProductError({required this.errorMessage});
}

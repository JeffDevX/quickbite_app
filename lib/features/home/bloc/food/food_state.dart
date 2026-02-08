part of 'food_bloc.dart';

@immutable
sealed class FoodState {}

final class FoodInitial extends FoodState {}

final class FoodLoading extends FoodState {}

final class FoodLoaded extends FoodState {
  final List<Food> foods;
  final String selectedCategory;

  FoodLoaded({required this.foods, required this.selectedCategory});
}

final class FoodError extends FoodState {
  final String errorMessage;

  FoodError({required this.errorMessage});
}

part of 'food_bloc.dart';

@immutable
sealed class FoodEvent {}

class FoodStarted extends FoodEvent {}

class FoodCategorySelected extends FoodEvent {
  final String category;

  FoodCategorySelected({required this.category});
}

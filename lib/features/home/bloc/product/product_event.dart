part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class LoadProducts extends ProductEvent {}

class ChangeCategory extends ProductEvent {
  final Category category;

  ChangeCategory(this.category);
}

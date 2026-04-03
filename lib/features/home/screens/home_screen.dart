import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite_app/features/home/bloc/product/product_bloc.dart';
import 'package:quickbite_app/features/home/models/food.dart';
import 'package:quickbite_app/features/home/widgets/food_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hola Jeffrey!'),
                        Text(
                          '¿Que comeras hoy?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    icon: Icon(Icons.logout),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
                child: SearchBar(
                  elevation: WidgetStatePropertyAll(0),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  leading: Icon(Icons.search),
                  hintText: 'Busca tu plato favorito',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: BlocBuilder<ProductBloc, ProducState>(
                    builder: (context, state) {
                      Category categorySelected = Category.combos;
                      if (state is ProductLoaded) {
                        categorySelected = state.selectedCategory;
                      }
                      return Row(
                        spacing: 10,
                        children: [
                          _categoryButton(
                            context: context,
                            category: Category.combos,
                            isSelected:
                                categorySelected == Category.combos
                                    ? true
                                    : false,
                          ),
                          _categoryButton(
                            context: context,
                            category: Category.hamburguesas,
                            isSelected:
                                categorySelected == Category.hamburguesas
                                    ? true
                                    : false,
                          ),
                          _categoryButton(
                            context: context,
                            category: Category.pizzas,
                            isSelected:
                                categorySelected == Category.pizzas
                                    ? true
                                    : false,
                          ),
                          _categoryButton(
                            context: context,
                            category: Category.bebidas,
                            isSelected:
                                categorySelected == Category.bebidas
                                    ? true
                                    : false,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ProductBloc, ProducState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ProductLoaded) {
                      return GridView.builder(
                        itemCount: state.filteredProducts.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final food = state.filteredProducts[index];
                          //final item = state.foods[index];
                          return FoodWidget(food: food);
                        },
                      );
                    } else if (state is ProductError) {
                      return Center(child: Text(state.errorMessage));
                    }

                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _categoryButton extends StatelessWidget {
  final BuildContext context;
  final bool isSelected;
  final Category category;
  const _categoryButton({
    required this.isSelected,
    required this.context,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          () => context.read<ProductBloc>().add(ChangeCategory(category)),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          isSelected ? Colors.deepOrange : null,
        ),
      ),
      child: Text(
        category.name,
        style: TextStyle(color: isSelected ? Colors.white : null),
      ),
    );
  }
}

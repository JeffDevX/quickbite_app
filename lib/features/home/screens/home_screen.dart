import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite_app/features/home/bloc/food/food_bloc.dart';
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
                        SearchBar(
                          leading: Icon(Icons.search),
                          hintText: 'Busca tu plato favorito',
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
              Row(
                children: [
                  ElevatedButton(onPressed: () {}, child: Text('Hamburguesas')),
                  ElevatedButton(onPressed: () {}, child: Text('Pizzas')),
                  ElevatedButton(onPressed: () {}, child: Text('Bebidas')),
                ],
              ),
              Expanded(
                child: BlocBuilder<FoodBloc, FoodState>(
                  builder: (context, state) {
                    if (state is FoodLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is FoodLoaded) {
                      return GridView.builder(
                        itemCount: state.foods.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final item = state.foods[index];
                          return FoodWidget(
                            foodImage: item.image,
                            foodName: item.name,
                            foodPrice: item.price,
                          );
                        },
                      );
                    } else if (state is FoodError) {
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

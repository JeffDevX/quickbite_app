import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite_app/features/cart/bloc/cart_bloc.dart';
import 'package:quickbite_app/features/cart/bloc/cart_state.dart';
import 'package:quickbite_app/features/cart/widgets/view_cart_button.dart';
import 'package:quickbite_app/features/home/bloc/product/product_bloc.dart';
import 'package:quickbite_app/features/home/models/food.dart';
import 'package:quickbite_app/features/home/widgets/food_widget.dart';
import 'package:quickbite_app/routes/app_router.dart';

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
              // 1. Cabecera con saludo y botón de logout
              _buildHeader(context),

              const SizedBox(height: 15),

              // 2. Barra de búsqueda
              _buildSearchBar(),

              // 3. Listado de categorías (Filtros)
              _buildCategoryList(),

              // 4. Grid de productos (Cuerpo principal)
              Expanded(child: _buildProductGrid()),

              // 5. Botón flotante del carrito (Solo aparece si hay items)
              _buildCartFloatingButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --- COMPONENTES SEPARADOS ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola Jeffrey!', style: TextStyle(color: Colors.grey)),
            Text(
              '¿Que comeras hoy?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            await authRepository.signOut();

            if (context.mounted) {
              context.go('/login');
            }
          },
          icon: const Icon(Icons.logout, color: Colors.deepOrange),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 45,
      child: SearchBar(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        leading: const Icon(Icons.search, color: Colors.grey),
        hintText: 'Busca tu plato favorito',
        hintStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Padding(
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
              children:
                  Category.values.map((category) {
                    final isSelected = categorySelected == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed:
                            () => context.read<ProductBloc>().add(
                              ChangeCategory(category),
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? Colors.deepOrange : Colors.white,
                          foregroundColor:
                              isSelected ? Colors.white : Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color:
                                  isSelected
                                      ? Colors.deepOrange
                                      : Colors.grey[300]!,
                            ),
                          ),
                        ),
                        child: Text(category.name),
                      ),
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return BlocBuilder<ProductBloc, ProducState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          if (state.filteredProducts.isEmpty) {
            return const Center(
              child: Text("No hay productos en esta categoría"),
            );
          }
          return GridView.builder(
            itemCount: state.filteredProducts.length,
            padding: const EdgeInsets.only(bottom: 20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return FoodWidget(food: state.filteredProducts[index]);
            },
          );
        } else if (state is ProductError) {
          return Center(child: Text(state.errorMessage));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCartFloatingButton() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // El botón solo se muestra si hay items y no estamos en un estado de éxito/limpieza
        if (state.items.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ViewCartButton(state: state),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

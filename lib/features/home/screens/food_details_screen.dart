import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbite_app/features/cart/bloc/cart_bloc.dart';
import 'package:quickbite_app/features/cart/bloc/cart_state.dart';
import 'package:quickbite_app/features/cart/widgets/view_cart_button.dart';
import 'package:quickbite_app/features/home/models/cart_items.dart';
import 'package:quickbite_app/features/home/models/food.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Food food;
  const FoodDetailsScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El botón inferior solo aparece si hay algo en el carrito
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.items.isNotEmpty) {
                return ViewCartButton(state: state);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Añadido para evitar errores de overflow en pantallas pequeñas
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Imagen con botón de regreso
            _buildImageHeader(context),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y Precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          food.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      Text(
                        '\$${food.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Selector de Cantidad (La lógica central)
                  _buildQuantitySelector(),

                  const SizedBox(height: 25),

                  // Descripción
                  const Text(
                    'Descripción',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    food.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para la imagen con el Hero y el botón de volver
  Widget _buildImageHeader(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: food.name,
          child: CachedNetworkImage(
            imageUrl: food.pictureUrl,
            height: 400,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        // Botón de regreso con delay para la animación
        FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox();
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  child: BackButton(
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Widget que maneja los botones + y -
  Widget _buildQuantitySelector() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // Buscamos ignorando mayúsculas/minúsculas y espacios
        final cartItem = state.items.firstWhere(
          (item) =>
              item.food.name.trim().toLowerCase() ==
              food.name.trim().toLowerCase(),
          orElse: () => CartItems(food: food, quantity: 0),
        );

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
            children: [
              _quantityButton(
                icon: Icons.remove,
                onPressed:
                    cartItem.quantity > 0
                        ? () => context.read<CartBloc>().add(
                          DecrementQuantity(food),
                        )
                        : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  cartItem.quantity.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              _quantityButton(
                icon: Icons.add,
                onPressed:
                    () => context.read<CartBloc>().add(IncrementQuantity(food)),
              ),
            ],
          ),
        );
      },
    );
  }

  // Botón circular pequeño para +/-
  Widget _quantityButton({required IconData icon, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: Colors.white,
      style: IconButton.styleFrom(
        backgroundColor: onPressed == null ? Colors.grey : Colors.deepOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

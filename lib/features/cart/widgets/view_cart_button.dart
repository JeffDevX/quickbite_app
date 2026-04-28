import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite_app/features/cart/bloc/cart_state.dart';

class ViewCartButton extends StatelessWidget {
  final CartState state;
  const ViewCartButton({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3), // Sombra más visible
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Sección de texto
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.items.length} ${state.items.length > 1 ? 'productos' : 'producto'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Ver Carrito',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            const Spacer(), // Empuja el precio al final
            // Sección del precio con botón estilizado
            ElevatedButton(
              onPressed: () => context.push('/cart'),
              child: Text(
                '\$${state.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

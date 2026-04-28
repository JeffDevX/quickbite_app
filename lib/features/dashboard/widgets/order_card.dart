import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbite_app/features/dashboard/orders_bloc/orders_bloc.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Si el ID es corto, substring puede dar error. Mejor validamos:
    final String orderId = order['id'] ?? 'S/N';
    final String displayId =
        orderId.length > 5 ? orderId.substring(orderId.length - 5) : orderId;

    // Luego en el Text:

    final String status = order['status'] ?? 'pendiente';
    final List<dynamic> items = order['items'] ?? [];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Orden: ...$displayId'),
                _StatusBadge(status: status),
              ],
            ),
            const Divider(),
            // Lista de productos del pedido
            // Busca esta línea en tu OrderCard y cámbiala:
            ...items.map(
              (item) => Text('• ${item['quantity']}x ${item['product_name']}'),
            ),
            const SizedBox(height: 16),

            // Acciones dinámicas según el estado
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'pendiente')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed:
                        () => _updateStatus(context, orderId, 'preparando'),
                    child: const Text(
                      'Empezar Preparación',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (status == 'preparando')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => _updateStatus(context, orderId, 'listo'),
                    child: const Text(
                      'Pedido Listo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (status == 'listo')
                  const Text(
                    '✅ Esperando entrega',
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(BuildContext context, String id, String newStatus) {
    context.read<OrdersBloc>().add(UpdateOrderStatus(id, newStatus));
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'preparando':
        color = Colors.blue;
        break;
      case 'listo':
        color = Colors.green;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

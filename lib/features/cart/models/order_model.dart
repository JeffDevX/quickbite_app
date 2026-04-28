import 'package:quickbite_app/features/home/models/cart_items.dart';

class OrderModel {
  final String orderId;
  final String clientId;
  final DateTime date;
  final List<CartItems> items;
  final double total;
  final String status;

  OrderModel({
    required this.orderId,
    required this.clientId,
    required this.date,
    required this.items,
    required this.total,
    this.status = 'pendiente',
  });

  Map<String, dynamic> toMap() {
    return {
      'client_id': clientId,
      'date': date,
      'status': status,
      'total': total,
      'items':
          items
              .map(
                (x) => {
                  'product_name': x.food.name,
                  'quantity': x.quantity,
                  'unit_price': x.food.price,
                  'subtotal': x.totalPrice,
                },
              )
              .toList(),
    };
  }
}

import 'package:cloud_functions/cloud_functions.dart';

class OrdersRepository {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Obtener todos los pedidos
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      final result = await _functions.httpsCallable('getallorders').call();
      if (result.data['success'] == true) {
        final List<dynamic> rawOrders = result.data['data'];
        // ESTA LÍNEA ES CLAVE: Convierte cada pedido al tipo Map<String, dynamic>
        return rawOrders
            .map((order) => Map<String, dynamic>.from(order))
            .toList();
      }
      throw Exception("Error al obtener pedidos");
    } catch (e) {
      throw Exception("Error de conexión con el microservicio");
    }
  }

  // Actualizar estado de un pedido
  Future<void> updateStatus(String orderId, String newStatus) async {
    try {
      await _functions.httpsCallable('updateorderstatus').call({
        'orderId': orderId,
        'newStatus': newStatus,
      });
    } catch (e) {
      throw Exception("No se pudo actualizar el estado");
    }
  }
}

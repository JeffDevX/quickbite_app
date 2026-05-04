import 'package:cloud_functions/cloud_functions.dart';
import 'package:quickbite_app/features/home/models/food.dart';

class ProductsRepository {
  // Cambiamos Firestore por Functions
  final FirebaseFunctions _functions;

  ProductsRepository({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  /// Obtiene el catálogo completo (Productos y Categorías) desde el microservicio
  Future<Map<String, dynamic>> getCatalog() async {
    try {
      final result = await _functions.httpsCallable('getcatalog').call();

      // 1. Convertimos la respuesta raíz a un mapa compatible con String
      final Map<String, dynamic> response = Map<String, dynamic>.from(
        result.data as Map,
      );

      if (response['success'] == true) {
        // 2. Extraemos la lista de productos
        final List<dynamic> productsRaw = response['products'];

        final List<Food> products =
            productsRaw.map((item) {
              // 3. Convertimos cada item de la lista
              final Map<String, dynamic> data = Map<String, dynamic>.from(
                item as Map,
              );
              return Food.fromJson(data);
            }).toList();

        // 4. Extraemos las categorías
        final List<dynamic> categories = response['categories'];

        return {'products': products, 'categories': categories};
      } else {
        throw Exception("Error en la respuesta del microservicio de catálogo");
      }
    } on FirebaseFunctionsException catch (e) {
      print('Error en Function: ${e.code} - ${e.message}');
      throw Exception(e.message ?? "Error al cargar el catálogo");
    } catch (e) {
      // Imprimimos el error real para no quedar a oscuras
      print('Error detallado en el mapeo: $e');
      throw Exception("Error al procesar los datos del servidor");
    }
  }
}

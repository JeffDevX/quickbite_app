import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:quickbite_app/features/cart/bloc/cart_state.dart';
import 'package:quickbite_app/features/home/models/cart_items.dart';
import 'package:quickbite_app/features/home/models/food.dart';

part 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  // Quitamos CartEvent de la definición si usas la nueva sintaxis, o lo dejas si prefieres
  CartBloc() : super(CartInitial()) {
    // NOTA: Al usar herencia, accedemos a state.items y state.total
    // porque están definidos en la clase base CartState.

    on<AddToCart>((event, emit) {
      final List<CartItems> updatedItems = List.from(state.items);
      final index = updatedItems.indexWhere(
        (x) => x.food.name == event.food.name,
      );

      if (index != -1) {
        updatedItems[index] = CartItems(
          food: updatedItems[index].food,
          quantity: updatedItems[index].quantity + 1,
        );
      } else {
        updatedItems.add(CartItems(food: event.food, quantity: 1));
      }

      emit(
        CartLoaded(items: updatedItems, total: _calculateTotal(updatedItems)),
      );
    });

    on<IncrementQuantity>((event, emit) {
      final List<CartItems> updatedItems = List.from(state.items);

      // Buscamos si ya existe en la lista
      final index = updatedItems.indexWhere(
        (item) => item.food.name.trim() == event.food.name.trim(),
      );

      if (index != -1) {
        // Si ya existe, creamos una copia con cantidad + 1
        updatedItems[index] = CartItems(
          food: updatedItems[index].food,
          quantity: updatedItems[index].quantity + 1,
        );
      } else {
        // SI NO EXISTE, LO AGREGAMOS (Esto es lo que faltaba)
        updatedItems.add(CartItems(food: event.food, quantity: 1));
      }

      emit(
        CartLoaded(items: updatedItems, total: _calculateTotal(updatedItems)),
      );
    });

    on<DecrementQuantity>((event, emit) {
      final List<CartItems> updatedItems = [];

      for (var item in state.items) {
        if (item.food.name == event.food.name) {
          if (item.quantity > 1) {
            updatedItems.add(
              CartItems(food: item.food, quantity: item.quantity - 1),
            );
          }
        } else {
          updatedItems.add(item);
        }
      }

      emit(
        CartLoaded(
          items: [...updatedItems],
          total: _calculateTotal(updatedItems),
        ),
      );
    });

    // Asegúrate de importar Firebase Auth si vas a usar el UID real
    // import 'package:firebase_auth/firebase_auth.dart';

    on<CheckoutRequested>((event, emit) async {
      final currentItems = state.items;
      final currentTotal = state.total;

      emit(CartLoading(items: currentItems, total: currentTotal));

      try {
        final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'createorder',
        );

        final List<Map<String, dynamic>> itemsFormatted =
            currentItems.map((item) {
              return {
                'product_name': item.food.name.toString(), // Forzamos String
                'quantity': item.quantity.toInt(), // Forzamos int
                'unit_price': item.food.price.toDouble(), // Forzamos double
                'subtotal': item.totalPrice.toDouble(),
              };
            }).toList();

        final result = await callable.call({
          // Si ya tienes login, usa: FirebaseAuth.instance.currentUser?.uid ?? 'anonimo'
          'client_id': 'jeffrey_test',
          'status': 'pendiente',
          'total': currentTotal.toDouble(),
          'items': itemsFormatted,
        });

        if (result.data['success'] == true) {
          emit(CartSuccess(orderId: result.data['orderId'].toString()));
        }
      } on FirebaseFunctionsException catch (e) {
        print(e.toString());
        emit(
          CartError(
            message: e.toString(),
            items: currentItems,
            total: currentTotal,
          ),
        );
      } catch (e) {
        print('error inesperado: $e');
      }
    });
  }

  double _calculateTotal(List<CartItems> items) {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }
}

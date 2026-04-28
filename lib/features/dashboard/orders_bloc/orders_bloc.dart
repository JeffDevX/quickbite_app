import 'package:bloc/bloc.dart';
import 'package:quickbite_app/features/dashboard/repository/orders_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository _repository;

  OrdersBloc(this._repository) : super(OrdersInitial()) {
    on<FetchOrders>((event, emit) async {
      emit(OrdersLoading());
      try {
        final orders = await _repository.getAllOrders();
        emit(OrdersLoaded(orders));
      } catch (e) {
        emit(OrdersError(e.toString()));
      }
    });

    on<UpdateOrderStatus>((event, emit) async {
      try {
        await _repository.updateStatus(event.orderId, event.newStatus);
        // Refrescamos la lista automáticamente
        add(FetchOrders());
      } catch (e) {
        emit(OrdersError("Error al actualizar: ${e.toString()}"));
      }
    });
  }
}

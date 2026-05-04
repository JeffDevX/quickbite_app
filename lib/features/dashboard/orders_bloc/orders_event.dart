part of 'orders_bloc.dart';

abstract class OrdersEvent {}

class FetchOrders extends OrdersEvent {}

class UpdateOrderStatus extends OrdersEvent {
  final String orderId;
  final String newStatus;
  UpdateOrderStatus(this.orderId, this.newStatus);
}

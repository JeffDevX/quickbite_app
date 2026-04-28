import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite_app/features/dashboard/orders_bloc/orders_bloc.dart';
import 'package:quickbite_app/features/dashboard/repository/orders_repository.dart';
import 'package:quickbite_app/features/dashboard/widgets/order_card.dart';
import 'package:quickbite_app/features/login/auth/bloc/auth_bloc.dart';
import 'package:quickbite_app/features/login/auth/bloc/auth_event.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel de Cocina',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              context.go('/login');
            },
          ),
        ],
      ),
      // En el build del DashboardScreen
      body: BlocProvider(
        create: (context) => OrdersBloc(OrdersRepository())..add(FetchOrders()),
        child: BlocListener<OrdersBloc, OrdersState>(
          listener: (context, state) {
            if (state is OrdersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, state) {
              if (state is OrdersLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is OrdersLoaded) {
                return RefreshIndicator(
                  onRefresh:
                      () async => context.read<OrdersBloc>().add(FetchOrders()),
                  child: ListView.builder(
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      return OrderCard(
                        order: order,
                      ); // Pasa la data real a tu tarjeta
                    },
                  ),
                );
              }

              if (state is OrdersError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

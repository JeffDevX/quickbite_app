import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite_app/features/home/bloc/product/product_bloc.dart';
import 'package:quickbite_app/features/home/models/food.dart';
import 'package:quickbite_app/features/home/repository/products_repository.dart';
import 'package:quickbite_app/features/home/screens/food_details_screen.dart';
import 'package:quickbite_app/features/home/screens/home_screen.dart';
import 'package:quickbite_app/features/login/bloc/login_bloc.dart';
import 'package:quickbite_app/features/login/screens/login_screen.dart';
import 'package:quickbite_app/features/register/bloc/register_bloc.dart';
import 'package:quickbite_app/features/register/screens/register_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginScreen(),
        );
      },
    ),
    GoRoute(
      path: '/register',
      builder:
          (context, state) => BlocProvider(
            create: (context) => RegisterBloc(),
            child: const RegisterScreen(),
          ),
    ),
    GoRoute(
      path: '/home',
      builder:
          (context, state) => BlocProvider(
            create:
                (context) =>
                    ProductBloc(ProductsRepository())..add(LoadProducts()),
            child: const HomeScreen(),
          ),
    ),
    GoRoute(
      path: '/foodDetails',
      pageBuilder: (context, state) {
        final food = state.extra as Food;
        return CustomTransitionPage(
          child: BlocProvider(
            create: (context) => ProductBloc(ProductsRepository()),
            child: FoodDetailsScreen(food: food),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
  ],
);

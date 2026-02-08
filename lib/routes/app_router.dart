import 'package:go_router/go_router.dart';
import 'package:quickbite_app/features/home/bloc/food/food_bloc.dart';
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
            create: (context) => FoodBloc()..add(FoodStarted()),
            child: const HomeScreen(),
          ),
    ),
  ],
);

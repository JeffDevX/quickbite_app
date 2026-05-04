import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite_app/core/repositories/auth_repository.dart';
import 'package:quickbite_app/features/cart/screens/cart_screen.dart';
import 'package:quickbite_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:quickbite_app/features/home/models/food.dart';
import 'package:quickbite_app/features/home/screens/food_details_screen.dart';
import 'package:quickbite_app/features/home/screens/home_screen.dart';
import 'package:quickbite_app/features/login/auth/bloc/auth_bloc.dart';
import 'package:quickbite_app/features/login/auth/bloc/auth_state.dart';
import 'package:quickbite_app/features/login/bloc/login_bloc.dart';
import 'package:quickbite_app/features/login/screens/login_screen.dart';
import 'package:quickbite_app/features/register/bloc/register_bloc.dart';
import 'package:quickbite_app/features/register/screens/register_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final authRepository = AuthRepository();

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthInitial) return null;

    final bool loggedIn = authState is Authenticated;

    // 1. Definimos qué rutas son accesibles sin estar logueado
    final bool isLoggingIn = state.matchedLocation == '/login';
    final bool isRegistering = state.matchedLocation == '/register';

    // 2. Si no está logueado y no está en login NI en registro, mándalo a login
    if (!loggedIn && !isLoggingIn && !isRegistering) {
      return '/login';
    }

    // 3. Si ya está logueado e intenta ir a login o registro, mándalo a su home
    if (loggedIn && (isLoggingIn || isRegistering)) {
      return authState.role == 'admin' ? '/dashboard' : '/home';
    }

    // PROTECCIÓN DE ROL:
    if (loggedIn && state.matchedLocation == '/dashboard') {
      if (authState.role != 'admin') return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder:
          (context, state) => BlocProvider(
            create: (context) => LoginBloc(authRepository: authRepository),
            child: const LoginScreen(),
          ),
    ),
    GoRoute(
      path: '/register',
      builder:
          (context, state) => BlocProvider(
            create: (context) => RegisterBloc(authRepository: authRepository),
            child: const RegisterScreen(),
          ),
    ),
    // ELIMINADO EL BLOCPROVIDER DE AQUÍ
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/foodDetails',
      pageBuilder: (context, state) {
        final food = state.extra as Food;
        return CustomTransitionPage(
          child: FoodDetailsScreen(food: food),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
  ],
);

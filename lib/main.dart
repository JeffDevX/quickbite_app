import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbite_app/core/repositories/auth_repository.dart';
import 'package:quickbite_app/features/cart/bloc/cart_bloc.dart';
import 'package:quickbite_app/features/home/bloc/product/product_bloc.dart';
import 'package:quickbite_app/features/home/repository/products_repository.dart';
import 'package:quickbite_app/features/login/auth/bloc/auth_bloc.dart';
import 'package:quickbite_app/firebase_options.dart';
import 'package:quickbite_app/routes/app_router.dart';

void main() async {
  // 1. Asegura que los widgets estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa Firebase usando tus opciones específicas
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(
          create:
              (context) =>
                  ProductBloc(ProductsRepository())..add(LoadProducts()),
        ),
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'QuickBite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}

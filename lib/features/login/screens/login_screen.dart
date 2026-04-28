import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quickbite_app/features/login/auth/bloc/auth_bloc.dart';
import 'package:quickbite_app/features/login/auth/bloc/auth_state.dart';
import 'package:quickbite_app/features/login/bloc/login_bloc.dart';
import 'package:quickbite_app/features/login/bloc/login_state.dart';
import 'package:quickbite_app/features/login/widgets/app_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            spacing: 25,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLogo(),
              Text(
                'Quickbite',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('Comida deliciosa en un instante'),
              Form(
                child: MultiBlocListener(
                  listeners: [
                    // Escuchamos errores del LoginBloc (ej: contraseña mal)
                    BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginFailure) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.error)));
                        }
                      },
                    ),
                    // Escuchamos al AuthBloc para la navegación (Reactividad)
                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is Authenticated) {
                          if (state.role == 'admin') {
                            context.go('/dashboard');
                          } else {
                            context.go('/home');
                          }
                        }
                      },
                    ),
                  ],
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        // onChanged: (value) {
                        //   context.read<LoginBloc>().add(
                        //     LoginEmailChanged(value),
                        //   );
                        // },
                        decoration: InputDecoration(label: Text('Email')),
                      ),
                      TextFormField(
                        // onChanged:
                        //     (value) => context.read<LoginBloc>().add(
                        //       LoginPasswordChanged(value),
                        //     ),
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(label: Text('Contraseña')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(10),
                                        ),
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        HexColor('FF5722'),
                                      ),
                                    ),
                                    onPressed: () {
                                      final email = emailController.text;
                                      final password = passwordController.text;

                                      if (email.isNotEmpty &&
                                          password.isNotEmpty) {
                                        context.read<LoginBloc>().add(
                                          LoginSubmitted(
                                            email: email,
                                            password: password,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Por favor, completa los campos',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child:
                                        state is LoginLoading
                                            ? SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                            : Text(
                                              'Iniciar sesión',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: Text('Registrarse'),
              ),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(height: 1)),
                  Text('o accede con'),
                  Expanded(child: Divider(height: 1)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {}, child: Text('Google')),
                  TextButton(onPressed: () {}, child: Text('Facebook')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

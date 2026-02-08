import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite_app/features/login/bloc/login_bloc.dart';

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quickbite',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('Comida deliciosa en un instante'),
              Form(
                child: BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    //If login is successful, navigate to home
                    if (state.isSuccess) {
                      context.go('/home');
                    }
                    //If login fails, show error message
                    if (state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        onChanged: (value) {
                          context.read<LoginBloc>().add(
                            LoginEmailChanged(value),
                          );
                        },
                        decoration: InputDecoration(label: Text('Email')),
                      ),
                      TextFormField(
                        onChanged:
                            (value) => context.read<LoginBloc>().add(
                              LoginPasswordChanged(value),
                            ),
                        controller: passwordController,
                        decoration: InputDecoration(label: Text('Contraseña')),
                      ),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed:
                                () => context.read<LoginBloc>().add(
                                  LoginSubmitted(),
                                ),
                            child:
                                state.isLoading
                                    ? CircularProgressIndicator()
                                    : Text('Iniciar sesión'),
                          );
                        },
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

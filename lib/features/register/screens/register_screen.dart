import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite_app/features/register/bloc/register_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Crear cuenta',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ya tienes una cuenta?'),
                  InkWell(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => context.go('/login'),
                  ),
                ],
              ),
              Expanded(
                child: Form(
                  child: BlocListener<RegisterBloc, RegisterState>(
                    listener: (context, state) {
                      if (state.errorMessage.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      }

                      if (state.isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Usuario registrado')),
                        );
                        context.go('/login');
                      }
                    },
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged:
                              (value) => context.read<RegisterBloc>().add(
                                RegisterEmailChanged(value),
                              ),
                          controller: email,
                          decoration: InputDecoration(label: Text('Email')),
                        ),
                        TextFormField(
                          onChanged:
                              (value) => context.read<RegisterBloc>().add(
                                RegisterPasswordChanged(value),
                              ),
                          controller: password,
                          decoration: InputDecoration(label: Text('Password')),
                        ),
                        BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                context.read<RegisterBloc>().add(
                                  RegisterSubmitted(),
                                );
                              },
                              child:
                                  state.isLoading
                                      ? CircularProgressIndicator()
                                      : Text('Registrarse'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                'Haciendo click en Crear cuenta esta de acuerdo y reconoce los Terminos de uso y Politica de privacidad',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

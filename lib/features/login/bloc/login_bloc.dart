import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(
        LoginError(
          message: 'Por favor completa todos los campos',
          password: event.password,
          email: event.email,
        ),
      );
      return;
    }

    emit(LoginLoading(password: event.password, email: event.email));

    try {
      await Future.delayed(Duration(seconds: 2));
      emit(LoginSuccess(password: event.password, email: event.email));
    } catch (_) {
      emit(
        LoginError(
          message: 'Error al iniciar sesión',
          password: event.password,
          email: event.email,
        ),
      );
    }
  }
}

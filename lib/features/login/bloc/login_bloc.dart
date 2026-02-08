import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<LoginEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, errorMessage: null));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, errorMessage: null));
    });

    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(errorMessage: 'Por favor completa todos los campos'));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      await Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Error al iniar sesión'));
    }
  }
}

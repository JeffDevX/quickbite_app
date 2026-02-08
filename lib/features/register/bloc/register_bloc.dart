import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState()) {
    on<RegisterEmailChanged>(
      (event, emit) =>
          emit(state.copyWith(email: event.email, errorMessage: null)),
    );
    on<RegisterPasswordChanged>(
      (event, emit) =>
          emit(state.copyWith(password: event.password, errorMessage: null)),
    );
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(errorMessage: 'Por favor completa todos los campos'));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      await Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(isSuccess: true, isLoading: false));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Error al crear usuario'));
    }
  }
}

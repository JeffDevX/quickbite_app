import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickbite_app/core/repositories/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;
  RegisterBloc({required this.authRepository}) : super(RegisterState()) {
    on<RegisterFirstNameChanged>(
      (event, emit) =>
          emit(state.copyWith(firstName: event.firstName, errorMessage: null)),
    );

    on<RegisterLastNameChanged>(
      (event, emit) =>
          emit(state.copyWith(lastName: event.lastName, errorMessage: null)),
    );
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

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await authRepository.signUp(
        firstName: state.firstName,
        lastName: state.lastName,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(isSuccess: true, isLoading: false));
    } on FirebaseAuthException catch (e) {
      String message = "Error al crear usuario";
      if (e.code == 'email-already-in-use') {
        message = 'Este correo ya está registrado.';
      }
      emit(state.copyWith(errorMessage: message, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error técnico: $e', isLoading: false));
    }
  }
}

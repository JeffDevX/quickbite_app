import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickbite_app/core/repositories/auth_repository.dart';
import 'package:quickbite_app/features/login/bloc/login_state.dart';

// Eventos
abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginSubmitted({required this.email, required this.password});
}

// El Bloc usando tus estados abstractos
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      try {
        await authRepository.signIn(
          email: event.email,
          password: event.password,
        );

        emit(LoginSuccess());
      } on FirebaseAuthException catch (e) {
        String userFriendlyMessage;

        // Agrupamos los errores que revelan información sensible
        if (e.code == 'user-not-found' ||
            e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          userFriendlyMessage = 'El correo o la contraseña son incorrectos.';
        } else if (e.code == 'user-disabled') {
          userFriendlyMessage =
              'Esta cuenta ha sido deshabilitada por el administrador.';
        } else if (e.code == 'network-request-failed') {
          userFriendlyMessage = 'Error de conexión. Revisa tu internet.';
        } else {
          userFriendlyMessage =
              'No se pudo iniciar sesión. Inténtalo más tarde.';
        }

        emit(LoginFailure(userFriendlyMessage));
      } catch (e) {
        emit(LoginFailure('Ocurrió un error inesperado.'));
      }
    });
  }
}

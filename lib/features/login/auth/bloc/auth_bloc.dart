import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickbite_app/core/repositories/auth_repository.dart';
import 'package:quickbite_app/features/login/auth/bloc/auth_event.dart';
import 'package:quickbite_app/features/login/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepo;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc(this._authRepo) : super(AuthInitial()) {
    // Escuchar cambios de Firebase Auth en tiempo real
    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      add(AuthChanged(user));
    });

    on<AuthChanged>((event, emit) async {
      if (event.user == null) {
        emit(Unauthenticated());
      } else {
        // Al detectar un usuario, buscamos su rol en Firestore
        final role = await _authRepo.getUserRole(event.user!.uid);

        emit(
          Authenticated(
            uid: event.user!.uid,
            email: event.user!.email!,
            role: role,
          ),
        );
      }
    });

    on<LogoutRequested>((event, emit) async {
      await _authRepo.signOut();
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}

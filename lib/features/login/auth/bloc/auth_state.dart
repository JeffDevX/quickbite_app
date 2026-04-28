abstract class AuthState {}

class AuthInitial extends AuthState {} // App cargando

class Authenticated extends AuthState {
  final String uid;
  final String role;
  final String email;

  Authenticated({required this.uid, required this.role, required this.email});
}

class Unauthenticated extends AuthState {} // Usuario fuera

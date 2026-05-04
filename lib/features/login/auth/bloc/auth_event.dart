import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {}

// Este evento se dispara automáticamente cuando Firebase detecta un cambio de sesión
class AuthChanged extends AuthEvent {
  final User? user;
  AuthChanged(this.user);
}

// Evento manual para cerrar sesión
class LogoutRequested extends AuthEvent {}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Monitoriza el estado de la sesión
  Stream<User?> get userStream => _auth.authStateChanges();

  // Obtener el rol del usuario desde Firestore
  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'] ?? 'client';
      }
      return 'client';
    } catch (e) {
      return 'client';
    }
  }

  // Registro de nuevo usuario
  // lib/core/repositories/auth_repository.dart
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // LLAMADA AL MICROSERVICIO V2
      final result = await _functions.httpsCallable('registeruser').call({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      });

      if (result.data['success'] == true) {
        // IMPORTANTE: Después del registro vía Admin SDK en Cloud Functions,
        // el usuario NO queda logueado en el teléfono automáticamente.
        // Debes llamar a tu método de login para obtener la sesión activa.
        await signIn(email: email, password: password);
      }
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? "Error en el registro");
    }
  }

  // Inicio de sesión
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Cierre de sesión
  Future<void> signOut() async => await _auth.signOut();
}

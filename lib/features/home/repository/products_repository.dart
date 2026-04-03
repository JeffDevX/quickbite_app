import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickbite_app/features/home/models/food.dart';

class ProductsRepository {
  final FirebaseFirestore _firestore;

  ProductsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream reactivo en tiempo real
  Stream<List<Food>> getProducts() {
    // Debug: Check authentication status
    final user = FirebaseAuth.instance.currentUser;
    print('Current user: ${user?.uid ?? "Not authenticated"}');
    print('User email: ${user?.email ?? "No email"}');

    return _firestore
        .collection('products')
        .where('available', isEqualTo: true) // opcional pero recomendado
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList();
        });
  }
}

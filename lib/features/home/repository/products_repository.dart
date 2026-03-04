import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickbite_app/features/home/models/food_model.dart';

class ProductsRepository {
  final FirebaseFirestore _firestore;

  ProductsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream reactivo en tiempo real
  Stream<List<FoodModel>> getProducts() {
    return _firestore
        .collection('products')
        .where('available', isEqualTo: true) // opcional pero recomendado
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => FoodModel.fromJson(doc.data()))
              .toList();
        });
  }
}

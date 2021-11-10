import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/porduct_dao.dart';

class FirebaseProvider {
  late FirebaseFirestore _firestore;
  late CollectionReference _productsCollection;

  FirebaseProvider() {
    _firestore = FirebaseFirestore.instance;
    _productsCollection = _firestore.collection('products');
  }

  Future<void> saveProduct(ProductDAO product) =>
      _productsCollection.add(product.toMap());

  Future<void> updateProduct(ProductDAO product, String documentID) =>
      _productsCollection.doc(documentID).update(product.toMap());

  Future<void> deleteProduct(String documentID) =>
      _productsCollection.doc(documentID).delete();

  Stream<QuerySnapshot> getAllProducts() {
    return _productsCollection.snapshots();
  }
}

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/porduct_dao.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class FirebaseProvider {
  late FirebaseFirestore _firestore;
  late CollectionReference _productsCollection;

  FirebaseProvider() {
    _firestore = FirebaseFirestore.instance;
    _productsCollection = _firestore.collection('products');
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
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

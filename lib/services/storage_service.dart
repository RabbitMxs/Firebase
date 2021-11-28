import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:uuid/uuid.dart';

class Storage {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    String fileName = Uuid().v1();
    try {
      await storage.ref("/fotos/$fileName.jpg").putFile(file);
      return downloadURLExample(fileName);
    } on firebase_core.FirebaseException catch (e) {
      return e.code;
      // e.g, e.code == 'canceled'
    }
  }

  Future<String> downloadURLExample(String fileName) async {
    return await storage.ref("/fotos/$fileName.jpg").getDownloadURL();
  }
}

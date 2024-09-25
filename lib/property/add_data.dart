import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadimagetoStorage(String filename, Uint8List file) async {
    Reference ref = _storage.ref().child(filename);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downlaodurl = await snapshot.ref.getDownloadURL();
    return downlaodurl;
  }

  Future<String> saveData({required String id, required Uint8List file}) async {
    String resp = "ok";

    try {
      String imageUrl = await uploadimagetoStorage(id, file);
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }
}

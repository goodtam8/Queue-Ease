import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class StoreData {
  Future<String> uploadimagetoStorage(String filename, Uint8List file) async {
    
    Reference ref = _storage.ref().child("staff_profile").child(filename);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downlaodurl = await snapshot.ref.getDownloadURL();
    return downlaodurl;
  }
  Future<String> uploaduserimage(String filename, Uint8List file) async {
    
    Reference ref = _storage.ref().child("user_profile").child(filename);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downlaodurl = await snapshot.ref.getDownloadURL();
    return downlaodurl;
  }
  Future<String> uploadrestimage(String filename, Uint8List file) async {
    
    Reference ref = _storage.ref().child("restaurant").child(filename);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downlaodurl = await snapshot.ref.getDownloadURL();
    return downlaodurl;
  }

  Future<String> getImageUrl(String id) async {
    try {
       Reference ref = _storage.ref().child("staff_profile").child(id);
    final url=await ref.getDownloadURL();
    return url;
    } catch (e) {
      print(e);
      return "error";
    }
   
  }
  Future<String> getuserurl(String id) async {
    try {
       Reference ref = _storage.ref().child("user_profile").child(id);
    final url=await ref.getDownloadURL();
    return url;
    } catch (e) {
      print(e);
      return "error";
    }
   
  }
   Future<String> getresturl(String id) async {
    try {
       Reference ref = _storage.ref().child("restaurant").child(id);
    final url=await ref.getDownloadURL();
    return url;
    } catch (e) {
      print(e);
      return "error";
    }
   
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
    Future<String> saveuserdata({required String id, required Uint8List file}) async {
    String resp = "ok";

    try {
      String imageUrl = await uploaduserimage(id, file);
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }
    Future<String> saverestdata({required String id, required Uint8List file}) async {
    String resp = "ok";

    try {
      String imageUrl = await uploadrestimage(id, file);
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

}

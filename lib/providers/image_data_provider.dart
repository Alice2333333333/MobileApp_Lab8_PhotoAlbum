import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:photo_album/constants/constants.dart';

class ImageDataProvider {
  ImageDataProvider({
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future deleteFile(String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    Future deleteTask = reference.delete();
    return deleteTask;
  }

  Future<void> addDataFirestore(
    String docPath,
    Map<String, dynamic> dataNeedAdd,
  ) {
    return firebaseFirestore
        .collection(FirebaseConstants.pathImagesCollection)
        .doc(docPath)
        .set(dataNeedAdd);
  }

  Future<void> updateDataFirestore(
    String docPath,
    Map<String, dynamic> dataNeedUpdate,
  ) {
    return firebaseFirestore
        .collection(FirebaseConstants.pathImagesCollection)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Future<void> deleteDataFirestore(String docPath) {
    return firebaseFirestore
        .collection(FirebaseConstants.pathImagesCollection)
        .doc(docPath)
        .delete();
  }

  Stream<QuerySnapshot> getImagesStream({int limit = 4}) {
    return firebaseFirestore
        .collection(FirebaseConstants.pathImagesCollection)
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .snapshots();
  }
}

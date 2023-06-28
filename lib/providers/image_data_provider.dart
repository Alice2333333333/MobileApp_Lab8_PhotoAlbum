import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:photo_album/models/models.dart';

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

  Future<void> addDataFirestore(
    String collectionPath,
    String docPath,
    Map<String, dynamic> dataNeedAdd,
  ) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .set(dataNeedAdd);
  }

  Future<void> updateDataFirestore(
    String collectionPath,
    String docPath,
    Map<String, dynamic> dataNeedUpdate,
  ) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getImageStream({String docId = '', int limit = 0}) {
    return firebaseFirestore
        .collection("folder1")
        // .doc(docId)
        // .collection(docId)
        // .orderBy("timestamp", descending: true)
        // .limit(limit)
        .snapshots();
  }
}

// Provides Firebase instances using Riverpod for dependency injection.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_provider.g.dart';

/// Firebase Auth Instance
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

/// Firestore Instance
@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

/// Firebase Storage Instance
@riverpod
FirebaseStorage firebaseStorage(FirebaseStorageRef ref) {
  return FirebaseStorage.instance;
}

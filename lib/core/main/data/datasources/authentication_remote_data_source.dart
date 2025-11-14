import 'package:aconsia_app/core/main/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthenticationRemoteDataSource {
  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<String, String>> registerDokter({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<String, String>> registerPasien({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<String, String>> logout();

  Future<Either<String, String>> forgotPassword({
    required String email,
  });

  Future<Either<String, UserModel>> getCurrentUserData();

  Future<Either<String, String>> updateProfileCompleted({
    required String uid,
    required bool isCompleted,
  });

  Future<Either<String, String>> deleteAccount({
    required String uid,
  });
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthenticationRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<Either<String, UserModel>> login(
      {required String email, required String password}) async {
    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        return Left("Login failed: No user");
      }

      // Get user data from Firestore
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        return Left("User data not found");
      }

      // Convert to UserModel
      final userModel = UserModel.fromFirestore(doc);
      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left("Error FirebaseAuthException: ${e.message}");
    } catch (e) {
      return Left("Error: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, String>> logout() async {
    try {
      await firebaseAuth.signOut();
      return Right("Logout successful");
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "An error occurred");
    }
  }

  @override
  Future<Either<String, String>> registerDokter(
      {required String email,
      required String password,
      required String name}) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        return Left("Failed to create user");
      }

      // Create user document in Firestore
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'name': name,
        'role': 'dokter',
        'isProfileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return Right("Registrasi dokter berhasil");
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "An error occurred");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> registerPasien(
      {required String email,
      required String password,
      required String name}) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        return Left("Failed to create user");
      }

      // Create user document in Firestore
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'name': name,
        'role': 'pasien',
        'isProfileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return Right("Registrasi pasien berhasil");
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "An error occurred");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> forgotPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return Right("Email reset password telah dikirim");
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "An error occurred");
    }
  }

  @override
  Future<Either<String, UserModel>> getCurrentUserData() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left("User not authenticated");
      }

      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        return Left("User data not found");
      }

      return Right(UserModel.fromFirestore(doc));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> updateProfileCompleted(
      {required String uid, required bool isCompleted}) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'isProfileCompleted': isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return Right("Profile status updated");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteAccount({required String uid}) async {
    try {
      // Delete Firestore document
      await firestore.collection('users').doc(uid).delete();

      // Delete Firebase Auth user
      final user = firebaseAuth.currentUser;
      if (user != null && user.uid == uid) {
        await user.delete();
      }

      return Right("Account deleted successfully");
    } catch (e) {
      return Left(e.toString());
    }
  }
}

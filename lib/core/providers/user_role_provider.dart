// Use case for fetching the role of a user from Firestore based on their UID.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_role_provider.g.dart';

@riverpod
Future<String> userRole(UserRoleRef ref, String uid) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = doc.data();
  if (data == null || !data.containsKey('role')) {
    throw Exception('Role tidak ditemukan');
  }
  return data['role'] as String;
}

import 'package:cloud_firestore/cloud_firestore.dart';

String? formatTime(Timestamp? timestamp) {
  if (timestamp == null) return null;
  final dateTime = timestamp.toDate();
  return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}
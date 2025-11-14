// Converts Firestore Timestamps to and from JSON-compatible formats.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Timestamp? timestampFromJson(dynamic value) {
  if (value is Timestamp) return value;
  if (value is String) return Timestamp.fromDate(DateTime.parse(value));
  return null;
}

dynamic timestampToJson(Timestamp? timestamp) {
  return timestamp;
}

Timestamp? tryParseTanggal(String input) {
  try {
    // format d/M/yyyy → contoh 4/11/2025
    return Timestamp.fromDate(DateFormat('d/M/yyyy').parse(input));
  } catch (_) {
    try {
      // format yyyy-MM-dd → contoh 2025-11-04
      return Timestamp.fromDate(DateFormat('yyyy-MM-dd').parse(input));
    } catch (_) {
      return null;
    }
  }
}

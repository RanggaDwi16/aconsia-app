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

DateTime? dateTimeFromJson(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return null;
}

dynamic dateTimeToJson(DateTime? value) {
  if (value == null) return null;
  return Timestamp.fromDate(value);
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

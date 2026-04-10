import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KontenModel date parsing', () {
    test('parses Firestore Timestamp', () {
      final now = Timestamp.fromDate(DateTime(2026, 4, 8, 10, 30));
      final model = KontenModel.fromJson({
        'id': 'k1',
        'dokterId': 'd1',
        'judul': 'Konten A',
        'createdAt': now,
        'updatedAt': now,
      });

      expect(model.id, 'k1');
      expect(model.createdAt, DateTime(2026, 4, 8, 10, 30));
      expect(model.updatedAt, DateTime(2026, 4, 8, 10, 30));
    });

    test('parses ISO String', () {
      final model = KontenModel.fromJson({
        'id': 'k2',
        'dokterId': 'd1',
        'judul': 'Konten B',
        'createdAt': '2026-04-08T12:00:00.000Z',
      });

      expect(model.createdAt, isNotNull);
      expect(model.createdAt!.toUtc().year, 2026);
      expect(model.createdAt!.toUtc().month, 4);
      expect(model.createdAt!.toUtc().day, 8);
    });

    test('accepts null date values', () {
      final model = KontenModel.fromJson({
        'id': 'k3',
        'dokterId': 'd1',
        'judul': 'Konten C',
        'createdAt': null,
        'updatedAt': null,
      });

      expect(model.createdAt, isNull);
      expect(model.updatedAt, isNull);
    });
  });
}

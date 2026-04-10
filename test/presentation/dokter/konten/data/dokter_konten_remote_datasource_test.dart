import 'package:aconsia_app/presentation/dokter/konten/data/datasources/dokter_konten_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeKontenDocument', () {
    test('fills id from document id and maps legacy aliases', () {
      final normalized = normalizeKontenDocument(
        documentId: 'doc-123',
        raw: {
          'doctorId': 'dokter-1',
          'title': 'Judul Web',
          'anesthesiaType': 'General Anesthesia',
          'description': 'Deskripsi dari web',
        },
      );

      expect(normalized['id'], 'doc-123');
      expect(normalized['dokterId'], 'dokter-1');
      expect(normalized['judul'], 'Judul Web');
      expect(normalized['jenisAnestesi'], 'General Anesthesia');
      expect(normalized['indikasiTindakan'], 'Deskripsi dari web');
    });

    test('keeps canonical values when already present', () {
      final normalized = normalizeKontenDocument(
        documentId: 'doc-abc',
        raw: {
          'id': 'k-main',
          'dokterId': 'dokter-2',
          'judul': 'Judul Mobile',
          'jenisAnestesi': 'Spinal Anesthesia',
        },
      );

      expect(normalized['id'], 'k-main');
      expect(normalized['dokterId'], 'dokter-2');
      expect(normalized['judul'], 'Judul Mobile');
      expect(normalized['jenisAnestesi'], 'Spinal Anesthesia');
    });
  });
}

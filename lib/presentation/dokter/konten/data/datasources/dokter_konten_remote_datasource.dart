import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class DokterKontenRemoteDataSource {
  Future<Either<String, String>> createKonten({
    required KontenModel konten,
    required List<KontenSectionModel> sections,
  });

  Future<Either<String, KontenModel>> getKontenById({
    required String kontenId,
  });

  Future<Either<String, List<KontenSectionModel>>> getSectionsByKontenId({
    required String kontenId,
  });

  Future<Either<String, List<KontenModel>>> getKontenByDokterId({
    required String dokterId,
  });

  Future<Either<String, String>> updateKonten({
    required KontenModel konten,
    required KontenSectionModel section,
  });

  Future<Either<String, String>> updateSection({
    required KontenSectionModel section,
  });

  Future<Either<String, String>> deleteKonten({
    required String kontenId,
  });

  Future<Either<String, int>> getKontenCountByDokterId({
    required String dokterId,
  });
}

class DokterKontenRemoteDataSourceImpl implements DokterKontenRemoteDataSource {
  final FirebaseFirestore firestore;

  DokterKontenRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, String>> createKonten(
      {required KontenModel konten,
      required List<KontenSectionModel> sections}) async {
    try {
      // Use batch write untuk atomicity
      final batch = firestore.batch();

      // Create konten document
      final kontenRef = firestore.collection('konten').doc();
      final kontenWithId = konten.copyWith(id: kontenRef.id);
      batch.set(kontenRef, kontenWithId.toJson());

      // Create section documents
      for (int i = 0; i < sections.length; i++) {
        final sectionRef = firestore.collection('konten_sections').doc();
        final section = sections[i].copyWith(
          id: sectionRef.id,
          kontenId: kontenRef.id,
          urutan: i + 1,
        );
        batch.set(sectionRef, section.toJson());
      }

      await batch.commit();
      return Right(kontenRef.id);
    } catch (e) {
      return Left('Gagal membuat konten: $e');
    }
  }

  @override
  Future<Either<String, String>> deleteKonten(
      {required String kontenId}) async {
    try {
      final batch = firestore.batch();

      // Delete konten document
      batch.delete(firestore.collection('konten').doc(kontenId));

      // Delete all sections
      final sectionsSnapshot = await firestore
          .collection('konten_sections')
          .where('kontenId', isEqualTo: kontenId)
          .get();

      for (var doc in sectionsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return const Right('Konten berhasil dihapus.');
    } catch (e) {
      return Left('Gagal menghapus konten: $e');
    }
  }

  @override
  Future<Either<String, List<KontenModel>>> getKontenByDokterId(
      {required String dokterId}) async {
    try {
      final query = firestore
          .collection('konten')
          .where('dokterId', isEqualTo: dokterId)
          .orderBy('createdAt', descending: true);

      // Filter by status 'published' is removed to show all konten
      // Status field may not exist in all documents

      final snapshot = await query.get();
      final kontenList =
          snapshot.docs.map((doc) => KontenModel.fromJson(doc.data())).toList();

      return Right(kontenList);
    } catch (e) {
      return Left('Gagal mengambil konten: $e');
    }
  }

  @override
  Future<Either<String, KontenModel>> getKontenById(
      {required String kontenId}) async {
    try {
      final doc = await firestore.collection('konten').doc(kontenId).get();
      if (!doc.exists) {
        return Left('Konten tidak ditemukan.');
      }
      return Right(KontenModel.fromJson(doc.data()!));
    } catch (e) {
      return Left('Gagal mengambil konten: $e');
    }
  }

  @override
  Future<Either<String, int>> getKontenCountByDokterId(
      {required String dokterId}) async {
    try {
      final snapshot = await firestore
          .collection('konten')
          .where('dokterId', isEqualTo: dokterId)
          .count()
          .get();

      return Right(snapshot.count ?? 0);
    } catch (e) {
      return Left('Gagal menghitung konten: $e');
    }
  }

  @override
  Future<Either<String, List<KontenSectionModel>>> getSectionsByKontenId(
      {required String kontenId}) async {
    try {
      final query = await firestore
          .collection('konten_sections')
          .where('kontenId', isEqualTo: kontenId)
          .orderBy('urutan')
          .get();

      final sections = query.docs
          .map((doc) => KontenSectionModel.fromJson(doc.data()))
          .toList();

      print('SECTION DATASOURCE: Ditemukan ${sections.length} sections.');
      return Right(sections);
    } catch (e) {
      return Left('Gagal mengambil sections: $e');
    }
  }

  @override
  Future<Either<String, String>> updateKonten({
    required KontenModel konten,
    required KontenSectionModel section,
  }) async {
    try {
      await firestore
          .collection('konten')
          .doc(konten.id)
          .update(konten.toJson());
      await firestore
          .collection('konten_sections')
          .doc(section.id)
          .update(section.toJson());
      return const Right('Konten berhasil diperbarui.');
    } catch (e) {
      return Left('Gagal update konten: $e');
    }
  }

  @override
  Future<Either<String, String>> updateSection(
      {required KontenSectionModel section}) async {
    try {
      await firestore
          .collection('konten_sections')
          .doc(section.id)
          .update(section.toJson());
      return const Right('Section berhasil diperbarui.');
    } catch (e) {
      return Left('Gagal update section: $e');
    }
  }
}

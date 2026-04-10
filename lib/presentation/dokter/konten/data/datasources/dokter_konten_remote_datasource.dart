import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

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

  Future<Either<String, KontenSectionModel>> ensureSectionExistsForKonten({
    required KontenModel konten,
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
    final kontenRef = firestore.collection('konten').doc();
    var isParentCreated = false;
    try {
      final kontenWithId = konten.copyWith(id: kontenRef.id);
      debugPrint(
        '[KontenDS] create step=1 start dokterId=${konten.dokterId} kontenId=${kontenRef.id}',
      );
      await kontenRef.set(kontenWithId.toJson());
      isParentCreated = true;
      debugPrint('[KontenDS] create step=1 success kontenId=${kontenRef.id}');

      if (sections.isEmpty) {
        await deleteKonten(kontenId: kontenRef.id);
        return Left(
          'Gagal membuat konten: section wajib minimal 1 item.',
        );
      }

      debugPrint(
        '[KontenDS] create step=2 start kontenId=${kontenRef.id} sections=${sections.length}',
      );
      for (int i = 0; i < sections.length; i++) {
        final sectionRef = firestore
            .collection('konten')
            .doc(kontenRef.id)
            .collection('sections')
            .doc();
        final section = sections[i].copyWith(
          id: sectionRef.id,
          kontenId: kontenRef.id,
          urutan: i + 1,
        );
        await sectionRef.set(section.toJson());
      }
      debugPrint('[KontenDS] create step=2 success kontenId=${kontenRef.id}');

      return Right(kontenRef.id);
    } on FirebaseException catch (e) {
      debugPrint(
        '[KontenDS] create failed dokterId=${konten.dokterId} kontenId=${kontenRef.id} code=${e.code} err=${e.message}',
      );
      // Rollback best-effort for partial create.
      // If step-1 succeeded and step-2 failed, remove parent + created sections.
      if (isParentCreated) {
        try {
          final rollbackResult = await deleteKonten(kontenId: kontenRef.id);
          rollbackResult.fold(
            (failure) => debugPrint(
              '[KontenDS] create rollback failed kontenId=${kontenRef.id} error=$failure',
            ),
            (_) => debugPrint(
              '[KontenDS] create rollback success kontenId=${kontenRef.id}',
            ),
          );
        } catch (rollbackError) {
          debugPrint('[KontenDS] create rollback exception: $rollbackError');
        }
      }
      debugPrint(
        '[KontenDS] create failed dokterId=${konten.dokterId} path=konten/${kontenRef.id} code=${e.code}',
      );
      return Left(
        'Gagal membuat konten: [${e.code}] ${e.message ?? e.toString()}. Konten dibatalkan agar data tetap konsisten.',
      );
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
          .collection('konten')
          .doc(kontenId)
          .collection('sections')
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
      if (dokterId.trim().isEmpty) {
        debugPrint('[KontenDS] dokterId kosong, skip fetch konten.');
        return const Right([]);
      }

      final byDokterIdQuery = firestore
          .collection('konten')
          .where('dokterId', isEqualTo: dokterId)
          .get();
      final byDoctorIdQuery = firestore
          .collection('konten')
          .where('doctorId', isEqualTo: dokterId)
          .get();

      final snapshots = await Future.wait([byDokterIdQuery, byDoctorIdQuery]);
      final rawDocs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
      final seenIds = <String>{};

      for (final snap in snapshots) {
        for (final doc in snap.docs) {
          if (seenIds.add(doc.id)) {
            rawDocs.add(doc);
          }
        }
      }

      debugPrint(
        '[KontenDS] fetch dokterId=$dokterId rawDocs=${rawDocs.length}',
      );

      final kontenList = <KontenModel>[];
      for (final doc in rawDocs) {
        try {
          final normalized = normalizeKontenDocument(
            documentId: doc.id,
            raw: doc.data(),
          );
          kontenList.add(KontenModel.fromJson(normalized));
        } catch (e) {
          debugPrint('[KontenDS] gagal parse dokumen id=${doc.id}: $e');
        }
      }

      kontenList.sort((a, b) {
        final left = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final right = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return right.compareTo(left);
      });

      debugPrint(
        '[KontenDS] dokterId=$dokterId parsedDocs=${kontenList.length}',
      );

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
      final subcollectionQuery = await firestore
          .collection('konten')
          .doc(kontenId)
          .collection('sections')
          .orderBy('urutan')
          .get();

      final sectionsFromSubcollection = subcollectionQuery.docs
          .map(
            (doc) => KontenSectionModel.fromJson({
              ...doc.data(),
              'id': (doc.data()['id'] as String?)?.trim().isNotEmpty == true
                  ? doc.data()['id']
                  : doc.id,
              'kontenId': doc.data()['kontenId'] ?? kontenId,
            }),
          )
          .toList();

      if (sectionsFromSubcollection.isNotEmpty) {
        return Right(sectionsFromSubcollection);
      }

      // Legacy fallback for old data model (top-level collection).
      // If rules deny this path, we ignore and return empty list.
      try {
        final legacyQuery = await firestore
            .collection('konten_sections')
            .where('kontenId', isEqualTo: kontenId)
            .orderBy('urutan')
            .get();

        final sectionsFromLegacy = legacyQuery.docs
            .map(
              (doc) => KontenSectionModel.fromJson({
                ...doc.data(),
                'id': (doc.data()['id'] as String?)?.trim().isNotEmpty == true
                    ? doc.data()['id']
                    : doc.id,
              }),
            )
            .toList();

        if (sectionsFromLegacy.isNotEmpty) {
          return Right(sectionsFromLegacy);
        }
      } on FirebaseException catch (legacyException) {
        if (legacyException.code == 'permission-denied') {
          debugPrint(
            '[KontenDS] legacy konten_sections denied by rules (expected).',
          );
          return const Right([]);
        }
        rethrow;
      }

      return const Right([]);
    } catch (e) {
      return Left('Gagal mengambil sections: $e');
    }
  }

  @override
  Future<Either<String, KontenSectionModel>> ensureSectionExistsForKonten({
    required KontenModel konten,
  }) async {
    final kontenId = (konten.id ?? '').trim();
    if (kontenId.isEmpty) {
      return const Left('Gagal memastikan section: kontenId tidak valid.');
    }

    try {
      final subcollectionQuery = await firestore
          .collection('konten')
          .doc(kontenId)
          .collection('sections')
          .orderBy('urutan')
          .limit(1)
          .get();

      if (subcollectionQuery.docs.isNotEmpty) {
        final section = _mapSectionDocument(
          doc: subcollectionQuery.docs.first,
          fallbackKontenId: kontenId,
        );
        debugPrint('[KontenDS] ensureSection source=subcollection kontenId=$kontenId');
        return Right(section);
      }

      try {
        final legacyQuery = await firestore
            .collection('konten_sections')
            .where('kontenId', isEqualTo: kontenId)
            .orderBy('urutan')
            .limit(1)
            .get();

        if (legacyQuery.docs.isNotEmpty) {
          final legacyDoc = legacyQuery.docs.first;
          final subDocRef = firestore
              .collection('konten')
              .doc(kontenId)
              .collection('sections')
              .doc(legacyDoc.id);

          final now = DateTime.now();
          final mappedLegacy = _mapSectionDocument(
            doc: legacyDoc,
            fallbackKontenId: kontenId,
          );
          final migrated = mappedLegacy.copyWith(
            id: legacyDoc.id,
            kontenId: kontenId,
            createdAt: mappedLegacy.createdAt ?? now,
            updatedAt: now,
          );

          await subDocRef.set(migrated.toJson(), SetOptions(merge: true));

          debugPrint('[KontenDS] ensureSection source=legacy-migrated kontenId=$kontenId');
          return Right(migrated);
        }
      } on FirebaseException catch (legacyException) {
        if (legacyException.code == 'permission-denied') {
          debugPrint(
            '[KontenDS] ensureSection legacy access denied by rules (expected) kontenId=$kontenId',
          );
        } else {
          rethrow;
        }
      }

      final now = DateTime.now();
      final createdSectionRef = firestore
          .collection('konten')
          .doc(kontenId)
          .collection('sections')
          .doc();

      final seededSection = KontenSectionModel(
        id: createdSectionRef.id,
        kontenId: kontenId,
        urutan: 1,
        judulBagian: 'Bagian 1',
        isiKonten: (konten.indikasiTindakan ?? '').trim().isNotEmpty
            ? konten.indikasiTindakan!.trim()
            : '-',
        createdAt: now,
        updatedAt: now,
      );

      await createdSectionRef.set(seededSection.toJson());
      debugPrint('[KontenDS] ensureSection source=bootstrap kontenId=$kontenId');

      return Right(seededSection);
    } on FirebaseException catch (e) {
      return Left('Gagal memastikan section: [${e.code}] ${e.message ?? e.toString()}');
    } catch (e) {
      return Left('Gagal memastikan section: $e');
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
      if ((section.id ?? '').trim().isEmpty ||
          (section.kontenId ?? '').trim().isEmpty) {
        return const Left(
          'Gagal update section: id section atau kontenId tidak valid.',
        );
      }
      await firestore
          .collection('konten')
          .doc(section.kontenId)
          .collection('sections')
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
      if ((section.id ?? '').trim().isEmpty ||
          (section.kontenId ?? '').trim().isEmpty) {
        return const Left(
          'Gagal update section: id section atau kontenId tidak valid.',
        );
      }
      await firestore
          .collection('konten')
          .doc(section.kontenId)
          .collection('sections')
          .doc(section.id)
          .update(section.toJson());
      return const Right('Section berhasil diperbarui.');
    } catch (e) {
      return Left('Gagal update section: $e');
    }
  }
}

KontenSectionModel _mapSectionDocument({
  required QueryDocumentSnapshot<Map<String, dynamic>> doc,
  required String fallbackKontenId,
}) {
  return KontenSectionModel.fromJson({
    ...doc.data(),
    'id': (doc.data()['id'] as String?)?.trim().isNotEmpty == true
        ? doc.data()['id']
        : doc.id,
    'kontenId': doc.data()['kontenId'] ?? fallbackKontenId,
  });
}

Map<String, dynamic> normalizeKontenDocument({
  required String documentId,
  required Map<String, dynamic> raw,
}) {
  final normalized = Map<String, dynamic>.from(raw);

  normalized['id'] = (normalized['id'] as String?)?.trim().isNotEmpty == true
      ? normalized['id']
      : documentId;

  normalized['dokterId'] = normalized['dokterId'] ?? normalized['doctorId'];
  normalized['judul'] = normalized['judul'] ?? normalized['title'];
  normalized['jenisAnestesi'] =
      normalized['jenisAnestesi'] ?? normalized['anesthesiaType'];
  normalized['indikasiTindakan'] =
      normalized['indikasiTindakan'] ?? normalized['description'];
  normalized['aiKeywords'] = normalized['aiKeywords'] ?? normalized['keywords'];

  return normalized;
}

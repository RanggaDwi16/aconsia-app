import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasienAccessibleKontenParams {
  final String pasienId;
  final String dokterId;

  const PasienAccessibleKontenParams({
    required this.pasienId,
    required this.dokterId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasienAccessibleKontenParams &&
        other.pasienId == pasienId &&
        other.dokterId == dokterId;
  }

  @override
  int get hashCode => Object.hash(pasienId, dokterId);
}

final pasienAccessibleKontenProvider = FutureProvider.family
    .autoDispose<List<KontenModel>, PasienAccessibleKontenParams>(
  (ref, params) async {
    if (params.pasienId.trim().isEmpty || params.dokterId.trim().isEmpty) {
      return const [];
    }

    final firestore = FirebaseFirestore.instance;
    final kontenById = <String, KontenModel>{};

    Future<void> loadPublishedByField(String fieldName) async {
      final snapshot = await firestore
          .collection('konten')
          .where(fieldName, isEqualTo: params.dokterId)
          .where('status', isEqualTo: 'published')
          .get();

      for (final doc in snapshot.docs) {
        final model = _mapKontenDocument(doc);
        if ((model.id ?? '').isNotEmpty) {
          kontenById[model.id!] = model;
        }
      }
    }

    await Future.wait([
      loadPublishedByField('dokterId'),
      loadPublishedByField('doctorId'),
    ]);

    final assignedKontenIds = await _fetchAssignedKontenIds(
      firestore: firestore,
      pasienId: params.pasienId,
    );

    if (assignedKontenIds.isNotEmpty) {
      for (final kontenId in assignedKontenIds) {
        try {
          final doc = await firestore.collection('konten').doc(kontenId).get();
          if (!doc.exists || doc.data() == null) continue;
          final status =
              (doc.data()!['status'] as String? ?? '').trim().toLowerCase();
          if (status != 'published') continue;
          final model = _mapKontenDocument(doc);
          if ((model.id ?? '').isNotEmpty) {
            kontenById[model.id!] = model;
          }
        } on FirebaseException catch (e) {
          if (e.code == 'permission-denied') {
            debugPrint(
              '[PasienKonten] skip inaccessible assigned kontenId=$kontenId (permission-denied)',
            );
            continue;
          }
          rethrow;
        }
      }
    }

    final list = kontenById.values.toList()
      ..sort((a, b) {
        final left = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final right = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return right.compareTo(left);
      });

    return list;
  },
);

Future<Set<String>> _fetchAssignedKontenIds({
  required FirebaseFirestore firestore,
  required String pasienId,
}) async {
  final assignedIds = <String>{};
  try {
    final snapshot = await firestore
        .collection('assignments')
        .where('pasienId', isEqualTo: pasienId)
        .get();

    for (final doc in snapshot.docs) {
      final raw = doc.data();
      final status = (raw['status'] as String?)?.toLowerCase().trim() ?? '';
      if (status.isNotEmpty && status != 'assigned' && status != 'active') {
        continue;
      }
      final kontenId = (raw['kontenId'] as String?)?.trim() ?? '';
      if (kontenId.isNotEmpty) {
        assignedIds.add(kontenId);
      }
    }
  } on FirebaseException catch (e) {
    if (e.code == 'permission-denied') {
      debugPrint(
        '[PasienKonten] collection=assignments permission denied for pasienId=$pasienId',
      );
      return assignedIds;
    }
    rethrow;
  }

  return assignedIds;
}

KontenModel _mapKontenDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
  final raw = doc.data() ?? <String, dynamic>{};
  final json = Map<String, dynamic>.from(raw);

  json['id'] =
      (json['id'] as String?)?.trim().isNotEmpty == true ? json['id'] : doc.id;
  json['dokterId'] = json['dokterId'] ?? json['doctorId'];
  json['judul'] = json['judul'] ?? json['title'];
  json['jenisAnestesi'] = json['jenisAnestesi'] ?? json['anesthesiaType'];
  json['indikasiTindakan'] =
      json['indikasiTindakan'] ?? json['deskripsi'] ?? json['description'];

  return KontenModel.fromJson(json);
}

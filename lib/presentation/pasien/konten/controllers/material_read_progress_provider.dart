import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialReadProgress {
  const MaterialReadProgress({
    required this.kontenId,
    required this.totalSections,
    required this.completedSectionIds,
    required this.currentSectionIndex,
  });

  final String kontenId;
  final int totalSections;
  final List<String> completedSectionIds;
  final int currentSectionIndex;

  static const empty = MaterialReadProgress(
    kontenId: '',
    totalSections: 0,
    completedSectionIds: <String>[],
    currentSectionIndex: 0,
  );

  double get completionRate {
    if (totalSections <= 0) return 0;
    final ratio = completedSectionIds.length / totalSections;
    return (ratio * 100).clamp(0, 100).toDouble();
  }

  bool get isCompleted =>
      totalSections > 0 && completedSectionIds.length >= totalSections;

  bool get hasStarted =>
      completedSectionIds.isNotEmpty || currentSectionIndex > 0;

  String get statusLabel {
    if (isCompleted) return 'Selesai';
    if (hasStarted) return 'Sedang Dibaca';
    return 'Belum Dibaca';
  }

  String get actionLabel {
    if (isCompleted) return 'Ulangi';
    if (hasStarted) return 'Lanjutkan';
    return 'Mulai';
  }

  MaterialReadProgress copyWith({
    String? kontenId,
    int? totalSections,
    List<String>? completedSectionIds,
    int? currentSectionIndex,
  }) {
    return MaterialReadProgress(
      kontenId: kontenId ?? this.kontenId,
      totalSections: totalSections ?? this.totalSections,
      completedSectionIds: completedSectionIds ?? this.completedSectionIds,
      currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
    );
  }

  factory MaterialReadProgress.fromMap({
    required String kontenId,
    required Map<String, dynamic> map,
    required int fallbackTotalSections,
  }) {
    final rawCompleted = map['completedSectionIds'];
    final completed = rawCompleted is List
        ? rawCompleted
            .whereType<String>()
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(growable: false)
        : const <String>[];

    final rawCurrent = map['currentSectionIndex'];
    final rawTotal = map['totalSections'];

    final total = (rawTotal is num ? rawTotal.toInt() : fallbackTotalSections)
        .clamp(0, 9999);
    final current = (rawCurrent is num ? rawCurrent.toInt() : 0)
        .clamp(0, total == 0 ? 0 : total - 1);

    return MaterialReadProgress(
      kontenId: kontenId,
      totalSections: total,
      completedSectionIds: completed,
      currentSectionIndex: current,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completedSectionIds': completedSectionIds,
      'currentSectionIndex': currentSectionIndex,
      'totalSections': totalSections,
      'completionPercent': completionRate,
      'updatedAt': FieldValue.serverTimestamp(),
      if (isCompleted) 'completedAt': FieldValue.serverTimestamp(),
    };
  }
}

class MaterialReadProgressParams {
  const MaterialReadProgressParams({
    required this.pasienId,
    required this.kontenId,
    required this.totalSections,
  });

  final String pasienId;
  final String kontenId;
  final int totalSections;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaterialReadProgressParams &&
        other.pasienId == pasienId &&
        other.kontenId == kontenId &&
        other.totalSections == totalSections;
  }

  @override
  int get hashCode => Object.hash(pasienId, kontenId, totalSections);
}

final materialReadProgressMapProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, pasienId) async {
  if (pasienId.trim().isEmpty) return const <String, dynamic>{};
  final profile =
      await ref.watch(fetchPasienProfileProvider(pasienId: pasienId).future);
  final preOp = profile?.preOperativeAssessment;
  if (preOp == null) return const <String, dynamic>{};

  final raw = preOp['materialProgress'];
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
  return const <String, dynamic>{};
});

final materialReadProgressProvider = Provider.family<
    AsyncValue<MaterialReadProgress>,
    MaterialReadProgressParams>((ref, params) {
  if (params.pasienId.trim().isEmpty || params.kontenId.trim().isEmpty) {
    return const AsyncValue.data(MaterialReadProgress.empty);
  }

  final progressMapAsync =
      ref.watch(materialReadProgressMapProvider(params.pasienId));

  return progressMapAsync.whenData((map) {
    final raw = map[params.kontenId];
    if (raw is Map<String, dynamic>) {
      return MaterialReadProgress.fromMap(
        kontenId: params.kontenId,
        map: raw,
        fallbackTotalSections: params.totalSections,
      );
    }
    if (raw is Map) {
      return MaterialReadProgress.fromMap(
        kontenId: params.kontenId,
        map: raw.map((key, value) => MapEntry(key.toString(), value)),
        fallbackTotalSections: params.totalSections,
      );
    }
    return MaterialReadProgress(
      kontenId: params.kontenId,
      totalSections: params.totalSections,
      completedSectionIds: const <String>[],
      currentSectionIndex: 0,
    );
  });
});

class SaveMaterialReadProgressPayload {
  const SaveMaterialReadProgressPayload({
    required this.pasienId,
    required this.progress,
  });

  final String pasienId;
  final MaterialReadProgress progress;
}

class SaveMaterialReadProgressNotifier extends StateNotifier<AsyncValue<void>> {
  SaveMaterialReadProgressNotifier(this._ref)
      : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> save(SaveMaterialReadProgressPayload payload) async {
    if (payload.pasienId.trim().isEmpty ||
        payload.progress.kontenId.trim().isEmpty) {
      return;
    }

    state = const AsyncValue.loading();

    try {
      final firestore = FirebaseFirestore.instance;
      final docRef =
          firestore.collection('pasien_profiles').doc(payload.pasienId);
      final doc = await docRef.get();
      final data = doc.data() ?? const <String, dynamic>{};

      final preOpRaw = data['preOperativeAssessment'];
      final preOp = preOpRaw is Map<String, dynamic>
          ? Map<String, dynamic>.from(preOpRaw)
          : preOpRaw is Map
              ? Map<String, dynamic>.from(preOpRaw.cast<String, dynamic>())
              : <String, dynamic>{};

      final materialRaw = preOp['materialProgress'];
      final materialProgress = materialRaw is Map<String, dynamic>
          ? Map<String, dynamic>.from(materialRaw)
          : materialRaw is Map
              ? Map<String, dynamic>.from(materialRaw.cast<String, dynamic>())
              : <String, dynamic>{};

      materialProgress[payload.progress.kontenId] = payload.progress.toMap();
      preOp['materialProgress'] = materialProgress;

      await docRef.set({
        'preOperativeAssessment': preOp,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _ref.invalidate(fetchPasienProfileProvider);
      _ref.invalidate(materialReadProgressMapProvider(payload.pasienId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final saveMaterialReadProgressProvider =
    StateNotifierProvider<SaveMaterialReadProgressNotifier, AsyncValue<void>>(
  (ref) => SaveMaterialReadProgressNotifier(ref),
);

class MedicationEntry {
  final String name;
  final String dose;
  final String frequency;

  const MedicationEntry({
    required this.name,
    required this.dose,
    required this.frequency,
  });

  factory MedicationEntry.empty() => const MedicationEntry(
        name: '',
        dose: '',
        frequency: '',
      );

  factory MedicationEntry.fromMap(Map<String, dynamic> map) {
    return MedicationEntry(
      name: (map['name'] ?? '').toString(),
      dose: (map['dose'] ?? '').toString(),
      frequency: (map['frequency'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name.trim(),
      'dose': dose.trim(),
      'frequency': frequency.trim(),
    };
  }

  bool get isValid =>
      name.trim().isNotEmpty &&
      dose.trim().isNotEmpty &&
      frequency.trim().isNotEmpty;

  MedicationEntry copyWith({
    String? name,
    String? dose,
    String? frequency,
  }) {
    return MedicationEntry(
      name: name ?? this.name,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
    );
  }
}

class PreOperativeAssessmentFormData {
  final String hasAnesthesiaHistory;
  final String anesthesiaComplications;
  final String hasDrugAllergy;
  final String allergyDetails;
  final String allergyReaction;
  final String takingMedication;
  final List<MedicationEntry> medicationList;
  final String smokingStatus;
  final String cigarettesPerDay;
  final String alcoholStatus;
  final String drugUse;
  final bool hasDiabetes;
  final bool hasHypertension;
  final bool hasAsthma;
  final bool hasHeartDisease;
  final bool hasStroke;
  final bool hasKidneyDisease;
  final bool hasLiverDisease;
  final bool hasEpilepsy;
  final String otherDiseases;
  final bool confirmationChecked;

  const PreOperativeAssessmentFormData({
    required this.hasAnesthesiaHistory,
    required this.anesthesiaComplications,
    required this.hasDrugAllergy,
    required this.allergyDetails,
    required this.allergyReaction,
    required this.takingMedication,
    required this.medicationList,
    required this.smokingStatus,
    required this.cigarettesPerDay,
    required this.alcoholStatus,
    required this.drugUse,
    required this.hasDiabetes,
    required this.hasHypertension,
    required this.hasAsthma,
    required this.hasHeartDisease,
    required this.hasStroke,
    required this.hasKidneyDisease,
    required this.hasLiverDisease,
    required this.hasEpilepsy,
    required this.otherDiseases,
    required this.confirmationChecked,
  });

  factory PreOperativeAssessmentFormData.initial() {
    return const PreOperativeAssessmentFormData(
      hasAnesthesiaHistory: '',
      anesthesiaComplications: '',
      hasDrugAllergy: '',
      allergyDetails: '',
      allergyReaction: '',
      takingMedication: '',
      medicationList: [],
      smokingStatus: '',
      cigarettesPerDay: '',
      alcoholStatus: '',
      drugUse: 'Tidak',
      hasDiabetes: false,
      hasHypertension: false,
      hasAsthma: false,
      hasHeartDisease: false,
      hasStroke: false,
      hasKidneyDisease: false,
      hasLiverDisease: false,
      hasEpilepsy: false,
      otherDiseases: '',
      confirmationChecked: false,
    );
  }

  factory PreOperativeAssessmentFormData.fromStoredAssessment(
    Map<String, dynamic>? assessment,
  ) {
    final rawData = assessment?['data'];
    final data = rawData is Map<String, dynamic>
        ? rawData
        : (rawData is Map ? rawData.cast<String, dynamic>() : assessment);

    if (data == null) {
      return PreOperativeAssessmentFormData.initial();
    }

    final medicationsRaw = data['medicationList'];
    final medications = medicationsRaw is List
        ? medicationsRaw
            .map((item) => item is Map<String, dynamic>
                ? MedicationEntry.fromMap(item)
                : item is Map
                    ? MedicationEntry.fromMap(item.cast<String, dynamic>())
                    : MedicationEntry.empty())
            .where((item) =>
                item.name.trim().isNotEmpty ||
                item.dose.trim().isNotEmpty ||
                item.frequency.trim().isNotEmpty)
            .toList()
        : <MedicationEntry>[];

    bool readBool(String key) {
      final value = data[key];
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    }

    return PreOperativeAssessmentFormData(
      hasAnesthesiaHistory: (data['hasAnesthesiaHistory'] ?? '').toString(),
      anesthesiaComplications:
          (data['anesthesiaComplications'] ?? '').toString(),
      hasDrugAllergy: (data['hasDrugAllergy'] ?? '').toString(),
      allergyDetails: (data['allergyDetails'] ?? '').toString(),
      allergyReaction: (data['allergyReaction'] ?? '').toString(),
      takingMedication: (data['takingMedication'] ?? '').toString(),
      medicationList: medications,
      smokingStatus: (data['smokingStatus'] ?? '').toString(),
      cigarettesPerDay: (data['cigarettesPerDay'] ?? '').toString(),
      alcoholStatus: (data['alcoholStatus'] ?? '').toString(),
      drugUse: (data['drugUse'] ?? 'Tidak').toString(),
      hasDiabetes: readBool('hasDiabetes'),
      hasHypertension: readBool('hasHypertension'),
      hasAsthma: readBool('hasAsthma'),
      hasHeartDisease: readBool('hasHeartDisease'),
      hasStroke: readBool('hasStroke'),
      hasKidneyDisease: readBool('hasKidneyDisease'),
      hasLiverDisease: readBool('hasLiverDisease'),
      hasEpilepsy: readBool('hasEpilepsy'),
      otherDiseases: (data['otherDiseases'] ?? '').toString(),
      confirmationChecked: true,
    );
  }

  Map<String, dynamic> toDataMap() {
    return {
      'hasAnesthesiaHistory': hasAnesthesiaHistory.trim(),
      'anesthesiaComplications': anesthesiaComplications.trim(),
      'hasDrugAllergy': hasDrugAllergy.trim(),
      'allergyDetails': allergyDetails.trim(),
      'allergyReaction': allergyReaction.trim(),
      'takingMedication': takingMedication.trim(),
      'medicationList': medicationList.map((item) => item.toMap()).toList(),
      'smokingStatus': smokingStatus.trim(),
      'cigarettesPerDay': cigarettesPerDay.trim(),
      'alcoholStatus': alcoholStatus.trim(),
      'drugUse': drugUse.trim(),
      'hasDiabetes': hasDiabetes,
      'hasHypertension': hasHypertension,
      'hasAsthma': hasAsthma,
      'hasHeartDisease': hasHeartDisease,
      'hasStroke': hasStroke,
      'hasKidneyDisease': hasKidneyDisease,
      'hasLiverDisease': hasLiverDisease,
      'hasEpilepsy': hasEpilepsy,
      'otherDiseases': otherDiseases.trim(),
    };
  }

  List<String> selectedDiseaseLabels() {
    final labels = <String>[];
    if (hasDiabetes) labels.add('Diabetes');
    if (hasHypertension) labels.add('Hipertensi');
    if (hasAsthma) labels.add('Asma');
    if (hasHeartDisease) labels.add('Penyakit Jantung');
    if (hasStroke) labels.add('Stroke');
    if (hasKidneyDisease) labels.add('Penyakit Ginjal');
    if (hasLiverDisease) labels.add('Penyakit Hati');
    if (hasEpilepsy) labels.add('Epilepsi');
    return labels;
  }

  PreOperativeAssessmentFormData copyWith({
    String? hasAnesthesiaHistory,
    String? anesthesiaComplications,
    String? hasDrugAllergy,
    String? allergyDetails,
    String? allergyReaction,
    String? takingMedication,
    List<MedicationEntry>? medicationList,
    String? smokingStatus,
    String? cigarettesPerDay,
    String? alcoholStatus,
    String? drugUse,
    bool? hasDiabetes,
    bool? hasHypertension,
    bool? hasAsthma,
    bool? hasHeartDisease,
    bool? hasStroke,
    bool? hasKidneyDisease,
    bool? hasLiverDisease,
    bool? hasEpilepsy,
    String? otherDiseases,
    bool? confirmationChecked,
  }) {
    return PreOperativeAssessmentFormData(
      hasAnesthesiaHistory: hasAnesthesiaHistory ?? this.hasAnesthesiaHistory,
      anesthesiaComplications:
          anesthesiaComplications ?? this.anesthesiaComplications,
      hasDrugAllergy: hasDrugAllergy ?? this.hasDrugAllergy,
      allergyDetails: allergyDetails ?? this.allergyDetails,
      allergyReaction: allergyReaction ?? this.allergyReaction,
      takingMedication: takingMedication ?? this.takingMedication,
      medicationList: medicationList ?? this.medicationList,
      smokingStatus: smokingStatus ?? this.smokingStatus,
      cigarettesPerDay: cigarettesPerDay ?? this.cigarettesPerDay,
      alcoholStatus: alcoholStatus ?? this.alcoholStatus,
      drugUse: drugUse ?? this.drugUse,
      hasDiabetes: hasDiabetes ?? this.hasDiabetes,
      hasHypertension: hasHypertension ?? this.hasHypertension,
      hasAsthma: hasAsthma ?? this.hasAsthma,
      hasHeartDisease: hasHeartDisease ?? this.hasHeartDisease,
      hasStroke: hasStroke ?? this.hasStroke,
      hasKidneyDisease: hasKidneyDisease ?? this.hasKidneyDisease,
      hasLiverDisease: hasLiverDisease ?? this.hasLiverDisease,
      hasEpilepsy: hasEpilepsy ?? this.hasEpilepsy,
      otherDiseases: otherDiseases ?? this.otherDiseases,
      confirmationChecked: confirmationChecked ?? this.confirmationChecked,
    );
  }
}

import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_learning_summary_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScheduleSignaturePage extends ConsumerStatefulWidget {
  const ScheduleSignaturePage({
    super.key,
    this.embeddedInMainShell = true,
  });

  final bool embeddedInMainShell;

  @override
  ConsumerState<ScheduleSignaturePage> createState() =>
      _ScheduleSignaturePageState();
}

class _ScheduleSignaturePageState extends ConsumerState<ScheduleSignaturePage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Sesi login tidak ditemukan.')),
      );
    }

    final profileAsync = ref.watch(fetchPasienProfileProvider(pasienId: uid));

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return const Center(
                child: Text('Profil pasien belum tersedia.'),
              );
            }

            final dokterId = _safeText(profile.dokterId);
            final summaryAsync = uid.isNotEmpty && dokterId != '-'
                ? ref.watch(
                    pasienLearningSummaryProvider(
                      PasienLearningSummaryParams(
                        pasienId: uid,
                        dokterId: dokterId,
                      ),
                    ),
                  )
                : const AsyncValue.data(PasienLearningSummary.empty());
            final completionRate =
                summaryAsync.valueOrNull?.completionRate ?? 0;
            final canSchedule = completionRate >= 80;

            final preOp =
                profile.preOperativeAssessment ?? const <String, dynamic>{};
            final savedDate = _readScheduledDate(preOp);
            final savedTime = _readScheduledTime(preOp);

            _selectedDate ??= savedDate;
            _selectedTime ??= savedTime;

            if (!canSchedule) {
              return _BlockedState(
                completionRate: completionRate,
                onBackToDashboard: _onBack,
              );
            }

            final jenisOperasi = _safeText(profile.jenisOperasi);
            final tanggalOperasi = _readOperationDate(preOp);
            final rumahSakit = _readHospitalName(preOp);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(UiSpacing.md),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(
                        onBack: _onBack,
                      ),
                      const Gap(UiSpacing.md),
                      _SuccessStateBanner(completionRate: completionRate),
                      const Gap(UiSpacing.md),
                      const AconsiaInfoBanner(
                        icon: Icons.info_outline_rounded,
                        message:
                            'Tanda tangan informed consent akan dilakukan secara fisik di rumah sakit. Silakan pilih tanggal dan waktu yang sesuai dengan jadwal Anda.',
                        backgroundColor: Color(0xFFEFF6FF),
                        borderColor: Color(0xFFBFDBFE),
                        iconColor: UiPalette.blue600,
                        textColor: Color(0xFF1E3A8A),
                      ),
                      const Gap(UiSpacing.md),
                      AconsiaCardSurface(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pilih Jadwal',
                              style: UiTypography.label.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(UiSpacing.sm),
                            _PickerInput(
                              icon: Icons.calendar_today_outlined,
                              label: 'Tanggal',
                              value: _selectedDate == null
                                  ? ''
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_selectedDate!),
                              placeholder: 'Pilih tanggal',
                              onTap: _pickDate,
                            ),
                            const Gap(UiSpacing.sm),
                            _PickerInput(
                              icon: Icons.access_time_rounded,
                              label: 'Waktu',
                              value: _selectedTime == null
                                  ? ''
                                  : _formatTime24h(_selectedTime!),
                              placeholder: 'Pilih waktu',
                              onTap: _pickTime,
                            ),
                            if (savedDate != null && savedTime != null) ...[
                              const Gap(UiSpacing.sm),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(UiSpacing.sm),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xFF86EFAC)),
                                ),
                                child: Text(
                                  'Jadwal tersimpan: ${DateFormat('d MMMM yyyy', 'id_ID').format(savedDate)} pukul ${_formatTime24h(savedTime)}',
                                  style: UiTypography.bodySmall.copyWith(
                                    color: const Color(0xFF166534),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Gap(UiSpacing.md),
                      _OperationInfoCard(
                        jenisOperasi: jenisOperasi,
                        tanggalOperasi: tanggalOperasi,
                        rumahSakit: rumahSakit,
                      ),
                      const Gap(UiSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _onBack,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: UiSpacing.sm,
                                ),
                                side:
                                    const BorderSide(color: UiPalette.slate300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Batal'),
                            ),
                          ),
                          const Gap(UiSpacing.sm),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  _isSaving ? null : () => _saveSchedule(uid),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF16A34A),
                                foregroundColor: UiPalette.white,
                                disabledBackgroundColor: UiPalette.slate300,
                                disabledForegroundColor: UiPalette.slate100,
                                padding: const EdgeInsets.symmetric(
                                  vertical: UiSpacing.sm,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Simpan Jadwal',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Gagal memuat profil: $error'),
          ),
        ),
      ),
    );
  }

  void _onBack() {
    if (widget.embeddedInMainShell) {
      ref.read(selectedIndexPasienProvider.notifier).state = 0;
      return;
    }

    if (GoRouter.of(context).canPop()) {
      context.pop();
      return;
    }

    ref.read(selectedIndexPasienProvider.notifier).state = 0;
  }

  String _safeText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '-' : text;
  }

  DateTime? _readScheduledDate(Map<String, dynamic> preOp) {
    final raw = preOp['scheduledSignatureDate'];
    if (raw is Timestamp) return raw.toDate();
    if (raw is String && raw.trim().isNotEmpty) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  TimeOfDay? _readScheduledTime(Map<String, dynamic> preOp) {
    final raw = preOp['scheduledSignatureTime'];
    if (raw is String && raw.trim().isNotEmpty) {
      final parts = raw.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    }
    return null;
  }

  String _readOperationDate(Map<String, dynamic> preOp) {
    final raw = preOp['tanggalOperasi'] ??
        preOp['surgeryDate'] ??
        preOp['operationDate'];

    if (raw is Timestamp) {
      return DateFormat('d MMMM yyyy', 'id_ID').format(raw.toDate());
    }
    if (raw is DateTime) {
      return DateFormat('d MMMM yyyy', 'id_ID').format(raw);
    }
    if (raw is String && raw.trim().isNotEmpty) {
      final parsed = DateTime.tryParse(raw.trim());
      if (parsed != null) {
        return DateFormat('d MMMM yyyy', 'id_ID').format(parsed);
      }
      return raw.trim();
    }
    return '-';
  }

  String _readHospitalName(Map<String, dynamic> preOp) {
    final raw =
        preOp['rumahSakit'] ?? preOp['hospitalName'] ?? preOp['hospital'];
    if (raw is String && raw.trim().isNotEmpty) {
      return raw.trim();
    }
    return '-';
  }

  String _formatTime24h(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      locale: const Locale('id', 'ID'),
    );

    if (!mounted || picked == null) return;
    setState(() {
      _selectedDate = picked;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (!mounted || picked == null) return;
    setState(() {
      _selectedTime = picked;
    });
  }

  Future<void> _saveSchedule(String uid) async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih tanggal dan waktu')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final firestore = ref.read(firebaseFirestoreProvider);
      final docRef = firestore.collection('pasien_profiles').doc(uid);
      final snapshot = await docRef.get();
      final data = snapshot.data() ?? const <String, dynamic>{};
      final preOpRaw = data['preOperativeAssessment'];
      final preOp = preOpRaw is Map<String, dynamic>
          ? Map<String, dynamic>.from(preOpRaw)
          : preOpRaw is Map
              ? Map<String, dynamic>.from(preOpRaw.cast<String, dynamic>())
              : <String, dynamic>{};

      final dateOnly = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );
      final timeString = _formatTime24h(_selectedTime!);

      preOp['scheduledSignatureDate'] = dateOnly.toIso8601String();
      preOp['scheduledSignatureTime'] = timeString;
      preOp['scheduledSignatureUpdatedAt'] = FieldValue.serverTimestamp();

      await docRef.set({
        'preOperativeAssessment': preOp,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ref.invalidate(fetchPasienProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jadwal tanda tangan berhasil disimpan!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan jadwal: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text('Kembali'),
        ),
        const Gap(2),
        Text(
          'Jadwal Tanda Tangan',
          style: UiTypography.h1,
        ),
        const Gap(UiSpacing.xxs),
        Text(
          'Informed Consent Anestesi',
          style: UiTypography.body.copyWith(color: UiPalette.slate500),
        ),
      ],
    );
  }
}

class _BlockedState extends StatelessWidget {
  const _BlockedState({
    required this.completionRate,
    required this.onBackToDashboard,
  });

  final double completionRate;
  final VoidCallback onBackToDashboard;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AconsiaCardSurface(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
                    color: Color(0xFFDC2626),
                    size: 30,
                  ),
                ),
                const Gap(UiSpacing.sm),
                Text(
                  'Belum Memenuhi Syarat',
                  style: UiTypography.h2.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const Gap(UiSpacing.xs),
                Text(
                  'Anda perlu mencapai pemahaman minimal 80% sebelum dapat menjadwalkan tanda tangan. Saat ini: ${completionRate.toStringAsFixed(0)}%',
                  textAlign: TextAlign.center,
                  style: UiTypography.body.copyWith(color: UiPalette.slate600),
                ),
                const Gap(UiSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onBackToDashboard,
                    child: const Text('Kembali ke Dashboard'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessStateBanner extends StatelessWidget {
  const _SuccessStateBanner({
    required this.completionRate,
  });

  final double completionRate;

  @override
  Widget build(BuildContext context) {
    return AconsiaCardSurface(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF16A34A),
              size: 34,
            ),
          ),
          const Gap(UiSpacing.sm),
          Text(
            'Selamat! Anda Sudah Memenuhi Syarat',
            textAlign: TextAlign.center,
            style: UiTypography.h2.copyWith(fontSize: 22),
          ),
          const Gap(UiSpacing.xs),
          Text(
            'Pemahaman Anda: ${completionRate.toStringAsFixed(0)}%',
            style: UiTypography.body.copyWith(
              color: const Color(0xFF16A34A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerInput extends StatelessWidget {
  const _PickerInput({
    required this.icon,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final display = value.trim().isEmpty ? placeholder : value.trim();
    final isPlaceholder = value.trim().isEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(UiSpacing.sm),
        decoration: BoxDecoration(
          color: UiPalette.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: UiPalette.slate300),
        ),
        child: Row(
          children: [
            Icon(icon, color: UiPalette.slate500),
            const Gap(UiSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: UiTypography.caption.copyWith(
                      color: UiPalette.slate500,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    display,
                    style: UiTypography.body.copyWith(
                      color: isPlaceholder
                          ? UiPalette.slate400
                          : UiPalette.slate900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: UiPalette.slate500),
          ],
        ),
      ),
    );
  }
}

class _OperationInfoCard extends StatelessWidget {
  const _OperationInfoCard({
    required this.jenisOperasi,
    required this.tanggalOperasi,
    required this.rumahSakit,
  });

  final String jenisOperasi;
  final String tanggalOperasi;
  final String rumahSakit;

  @override
  Widget build(BuildContext context) {
    return AconsiaCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Info Operasi Anda',
            style: UiTypography.label.copyWith(fontWeight: FontWeight.w700),
          ),
          const Gap(UiSpacing.sm),
          _InfoRow(label: 'Jenis Operasi', value: jenisOperasi),
          _InfoRow(label: 'Tanggal Operasi', value: tanggalOperasi),
          _InfoRow(label: 'Rumah Sakit', value: rumahSakit),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: UiTypography.bodySmall.copyWith(
                color: UiPalette.slate500,
              ),
            ),
          ),
          Text(
            value,
            style: UiTypography.bodySmall.copyWith(
              color: UiPalette.slate900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

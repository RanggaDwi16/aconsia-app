import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_dropdown.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/dokter_konten_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_id/fetch_konten_by_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/fetch_sections_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/update_konten/patch_konten_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/data/data_konten.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/ensure_section_exists_for_konten.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditKontenPage extends HookConsumerWidget {
  final String kontenId;

  const EditKontenPage({super.key, required this.kontenId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final judulController = useTextEditingController();
    final jenisAnestesiController = useTextEditingController();
    final deskripsiSingkatController = useTextEditingController();
    final isiKontenController = useTextEditingController();

    final existingCreatedAt = useState<DateTime?>(null);
    final existingStatus = useState<String>('draft');
    final existingImageUrl = useState<String?>(null);
    final hasTriggeredSectionBootstrap = useRef(false);
    final isBootstrappingSection = useState(false);
    final bootstrapSectionError = useState<String?>(null);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final patchKonten = ref.watch(patchKontenProvider);

    final kontenAsync = ref.watch(fetchKontenByIdProvider(kontenId: kontenId));
    final sectionsAsync =
        ref.watch(fetchSectionsByKontenIdProvider(kontenId: kontenId));
    final ensureSectionExistsForKonten = EnsureSectionExistsForKonten(
      repository: ref.read(dokterKontenRepositoryProvider),
    );

    useEffect(() {
      if (kontenAsync is AsyncData<KontenModel>) {
        final konten = kontenAsync.value;
        judulController.text = konten.judul ?? '';
        jenisAnestesiController.text = konten.jenisAnestesi ?? '';
        deskripsiSingkatController.text = konten.indikasiTindakan ?? '';
        existingCreatedAt.value = konten.createdAt;
        final statusValue = (konten.status ?? 'draft').trim();
        existingStatus.value = statusValue.isEmpty ? 'draft' : statusValue;
        existingImageUrl.value = konten.gambarUrl;
      }

      if (sectionsAsync is AsyncData<List<KontenSectionModel>> &&
          sectionsAsync.value.isNotEmpty) {
        final section = sectionsAsync.value.first;
        isiKontenController.text = section.isiKonten ?? '';
      }

      return null;
    }, [kontenAsync, sectionsAsync]);

    useEffect(() {
      if (kontenAsync is! AsyncData<KontenModel> ||
          sectionsAsync is! AsyncData<List<KontenSectionModel>>) {
        return null;
      }

      final konten = kontenAsync.value;
      final sections = sectionsAsync.value;

      if (sections.isNotEmpty) {
        bootstrapSectionError.value = null;
        hasTriggeredSectionBootstrap.value = false;
        return null;
      }

      if (hasTriggeredSectionBootstrap.value || isBootstrappingSection.value) {
        return null;
      }

      final safeKontenId = (konten.id ?? '').trim();
      if (safeKontenId.isEmpty) {
        bootstrapSectionError.value = 'Konten tidak valid: id kosong.';
        return null;
      }

      hasTriggeredSectionBootstrap.value = true;
      isBootstrappingSection.value = true;
      bootstrapSectionError.value = null;
      debugPrint('[EditKonten] bootstrap section start kontenId=$safeKontenId');

      Future<void>(() async {
        final result = await ensureSectionExistsForKonten(
          EnsureSectionExistsForKontenParams(konten: konten),
        );

        result.fold(
          (failure) {
            debugPrint(
              '[EditKonten] bootstrap section failed kontenId=$safeKontenId error=$failure',
            );
            bootstrapSectionError.value = failure;
          },
          (section) {
            debugPrint(
              '[EditKonten] bootstrap section success kontenId=$safeKontenId sectionId=${section.id}',
            );
            bootstrapSectionError.value = null;
            ref.invalidate(fetchSectionsByKontenIdProvider(kontenId: kontenId));
          },
        );

        isBootstrappingSection.value = false;
      });

      return null;
    }, [kontenAsync, sectionsAsync]);

    useListenable(judulController);
    useListenable(jenisAnestesiController);
    useListenable(deskripsiSingkatController);
    useListenable(isiKontenController);

    final isEmpty = judulController.text.trim().isEmpty ||
        jenisAnestesiController.text.trim().isEmpty ||
        deskripsiSingkatController.text.trim().isEmpty ||
        isiKontenController.text.trim().isEmpty;

    final loadedSections = sectionsAsync.valueOrNull ?? const <KontenSectionModel>[];

    final shouldShowBootstrapLoader = kontenAsync.hasValue &&
        sectionsAsync.hasValue &&
        loadedSections.isEmpty &&
        !sectionsAsync.hasError &&
        bootstrapSectionError.value == null;

    final isFormReady = kontenAsync.hasValue &&
        sectionsAsync.hasValue &&
        loadedSections.isNotEmpty &&
        !isBootstrappingSection.value &&
        bootstrapSectionError.value == null &&
        !kontenAsync.hasError &&
        !sectionsAsync.hasError;

    void retrySectionsLoad() {
      hasTriggeredSectionBootstrap.value = false;
      bootstrapSectionError.value = null;
      ref.invalidate(fetchSectionsByKontenIdProvider(kontenId: kontenId));
    }

    return Scaffold(
      body: kontenAsync.when(
        data: (konten) => sectionsAsync.when(
          data: (sections) {
            if (isBootstrappingSection.value || shouldShowBootstrapLoader) {
              return _buildBootstrapState(context);
            }

            if (sections.isEmpty) {
              final errorMessage = bootstrapSectionError.value;
              final isPermissionDenied =
                  (errorMessage ?? '').contains('permission-denied');
              return _buildEmptySectionState(
                context,
                isPermissionDenied: isPermissionDenied,
                onRetry: retrySectionsLoad,
              );
            }

            return _buildFormContent(
              context,
              judulController: judulController,
              jenisAnestesiController: jenisAnestesiController,
              deskripsiSingkatController: deskripsiSingkatController,
              isiKontenController: isiKontenController,
            );
          },
          loading: () => _buildSectionLoadingState(context),
          error: (e, _) => _buildSectionErrorState(
            context,
            e,
            onRetry: retrySectionsLoad,
          ),
        ),
        loading: () => const AconsiaPageBackground(
          colors: [Color(0xFFF8FAFC), UiPalette.white],
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => _buildKontenErrorState(context, e),
      ),
      bottomNavigationBar: isFormReady
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Button.outlined(
                      onPressed: () => context.pop(),
                      label: 'Batal',
                      disabled: patchKonten.isLoading,
                      borderColor: UiPalette.slate300,
                      textColor: UiPalette.slate700,
                    ),
                  ),
                  const Gap(UiSpacing.sm),
                  Expanded(
                    child: Button.filled(
                      disabled: !isFormReady || isEmpty || patchKonten.isLoading,
                      onPressed: () async {
                        if (loadedSections.isEmpty) {
                          context.showErrorSnackbar(
                            context,
                            'Section konten belum tersedia. Silakan coba lagi.',
                          );
                          return;
                        }

                        final existingKonten = kontenAsync.valueOrNull;
                        final existingSection = loadedSections.first;
                        ref.read(patchKontenProvider.notifier).patchKonten(
                              konten: KontenModel(
                                id: kontenId,
                                dokterId: uid ?? existingKonten?.dokterId ?? '',
                                judul: judulController.text.trim(),
                                jenisAnestesi:
                                    jenisAnestesiController.text.trim(),
                                tataCara: existingKonten?.tataCara,
                                resikoTindakan: existingKonten?.resikoTindakan,
                                komplikasi: existingKonten?.komplikasi,
                                indikasiTindakan:
                                    deskripsiSingkatController.text.trim(),
                                prognosis: existingKonten?.prognosis,
                                alternatifLain: existingKonten?.alternatifLain,
                                gambarUrl: existingImageUrl.value,
                                jumlahBagian: existingKonten?.jumlahBagian ?? 1,
                                status: existingStatus.value,
                                createdAt: existingCreatedAt.value,
                                updatedAt: DateTime.now(),
                              ),
                              section: KontenSectionModel(
                                id: existingSection.id,
                                kontenId: kontenId,
                                judulBagian: (existingSection.judulBagian ?? '')
                                        .trim()
                                        .isEmpty
                                    ? 'Bagian 1'
                                    : existingSection.judulBagian,
                                isiKonten: isiKontenController.text.trim(),
                                urutan: existingSection.urutan ?? 1,
                                createdAt: existingSection.createdAt,
                                updatedAt: DateTime.now(),
                              ),
                              onSuccess: (_) {
                                context.showSuccessDialog(
                                  context,
                                  'Konten berhasil diperbarui.',
                                );
                                ref.invalidate(
                                    fetchKontenByIdProvider(kontenId: kontenId));
                                ref.invalidate(fetchSectionsByKontenIdProvider(
                                    kontenId: kontenId));
                                ref.invalidate(fetchKontenByDokterIdProvider(
                                    dokterId: uid ?? ''));
                                context.pop();
                              },
                              onError: (message) {
                                context.showErrorSnackbar(context, message);
                              },
                            );
                      },
                      label: patchKonten.isLoading
                          ? 'Menyimpan...'
                          : 'Simpan Perubahan',
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildFormContent(
    BuildContext context, {
    required TextEditingController judulController,
    required TextEditingController jenisAnestesiController,
    required TextEditingController deskripsiSingkatController,
    required TextEditingController isiKontenController,
  }) {
    return AconsiaPageBackground(
      colors: const [Color(0xFFF8FAFC), UiPalette.white],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AconsiaTopActionRow(
              title: 'Edit Konten',
              subtitle: 'Perubahan konten akan langsung diperbarui.',
              onBack: () => context.pop(),
            ),
            const Gap(UiSpacing.md),
            CustomTextField(
              isRequired: true,
              controller: judulController,
              labelText: 'Judul',
              hintText: 'Contoh: Persiapan Anestesi Spinal untuk Pasien',
            ),
            const Gap(UiSpacing.md),
            CustomDropdown(
              isRequired: true,
              items: jenisAnestesi,
              title: 'Jenis Anestesi',
              onChanged: (value) => jenisAnestesiController.text = value,
              selectedValue: jenisAnestesiController.text.isEmpty
                  ? null
                  : jenisAnestesiController.text,
            ),
            const Gap(UiSpacing.md),
            CustomTextField(
              isRequired: true,
              controller: deskripsiSingkatController,
              labelText: 'Deskripsi Singkat',
              hintText: 'Masukkan deskripsi singkat konten',
              maxLines: 3,
            ),
            const Gap(UiSpacing.md),
            CustomTextField(
              isRequired: true,
              controller: isiKontenController,
              labelText: 'Isi Konten',
              hintText: 'Masukkan isi konten edukasi',
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBootstrapState(BuildContext context) {
    return AconsiaPageBackground(
      colors: const [Color(0xFFF8FAFC), UiPalette.white],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AconsiaTopActionRow(
              title: 'Edit Konten',
              subtitle: 'Perbarui materi edukasi pasien',
              onBack: () => context.pop(),
            ),
            const Gap(UiSpacing.md),
            AconsiaCardSurface(
              borderColor: const Color(0xFFBFDBFE),
              padding: const EdgeInsets.all(UiSpacing.md),
              child: Row(
                children: const [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  Gap(UiSpacing.sm),
                  Expanded(
                    child: Text(
                      'Menyiapkan section konten...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: UiPalette.slate900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySectionState(
    BuildContext context, {
    required bool isPermissionDenied,
    required VoidCallback onRetry,
  }) {
    return AconsiaPageBackground(
      colors: const [Color(0xFFF8FAFC), UiPalette.white],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AconsiaTopActionRow(
              title: 'Edit Konten',
              subtitle: 'Perbarui materi edukasi pasien',
              onBack: () => context.pop(),
            ),
            const Gap(UiSpacing.md),
            AconsiaCardSurface(
              borderColor: const Color(0xFFFDE68A),
              padding: const EdgeInsets.all(UiSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Section konten belum tersedia',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.slate900,
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  Text(
                    isPermissionDenied
                        ? 'Akses section ditolak oleh server. Coba login ulang atau hubungi admin untuk memastikan izin dokter aktif.'
                        : 'Data section untuk konten ini belum ditemukan. Kami sudah mencoba membuat section awal otomatis, tetapi belum berhasil.',
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: UiPalette.slate600,
                      height: 1.35,
                    ),
                  ),
                  const Gap(UiSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Kembali'),
                        ),
                      ),
                      const Gap(UiSpacing.xs),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onRetry,
                          child: const Text('Coba Lagi'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLoadingState(BuildContext context) {
    return AconsiaPageBackground(
      colors: const [Color(0xFFF8FAFC), UiPalette.white],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AconsiaTopActionRow(
              title: 'Edit Konten',
              subtitle: 'Perbarui materi edukasi pasien',
              onBack: () => context.pop(),
            ),
            const Gap(UiSpacing.md),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionErrorState(
    BuildContext context,
    Object error, {
    required VoidCallback onRetry,
  }) {
    return AconsiaPageBackground(
      colors: const [Color(0xFFF8FAFC), UiPalette.white],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AconsiaTopActionRow(
              title: 'Edit Konten',
              subtitle: 'Perbarui materi edukasi pasien',
              onBack: () => context.pop(),
            ),
            const Gap(UiSpacing.md),
            AconsiaCardSurface(
              borderColor: const Color(0xFFFECACA),
              padding: const EdgeInsets.all(UiSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Section konten tidak bisa dimuat',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.slate900,
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  Text(
                    error.toString().contains('permission-denied')
                        ? 'Anda belum memiliki izin untuk membaca section konten ini. Coba login ulang atau hubungi admin.'
                        : 'Terjadi kendala saat mengambil section konten. Silakan coba lagi.',
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: UiPalette.slate600,
                      height: 1.35,
                    ),
                  ),
                  const Gap(UiSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Kembali'),
                        ),
                      ),
                      const Gap(UiSpacing.xs),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onRetry,
                          child: const Text('Coba Lagi'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKontenErrorState(BuildContext context, Object error) {
    return AconsiaPageBackground(
      colors: const [Color(0xFFF8FAFC), UiPalette.white],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AconsiaTopActionRow(
              title: 'Edit Konten',
              subtitle: 'Perbarui materi edukasi pasien',
              onBack: () => context.pop(),
            ),
            const Gap(UiSpacing.md),
            AconsiaCardSurface(
              borderColor: const Color(0xFFFECACA),
              padding: const EdgeInsets.all(UiSpacing.md),
              child: Text(
                'Gagal ambil konten: $error',
                style: const TextStyle(color: UiPalette.red600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

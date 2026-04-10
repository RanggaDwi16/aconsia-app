import 'package:aconsia_app/core/helpers/widgets/custom_search_field.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_list_by_dokter_id/fetch_pasien_list_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/widgets/list_pasien_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListActivePasienPage extends HookConsumerWidget {
  final bool embeddedInMainNav;

  const ListActivePasienPage({
    super.key,
    this.embeddedInMainNav = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final filterMode = useState(_ReviewFilter.all);

    final pasienList =
        ref.watch(fetchPasienListByDokterIdProvider(dokterId: uid ?? ''));

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchPasienListByDokterIdProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AconsiaTopActionRow(
                  title: embeddedInMainNav ? 'Pasien Saya' : 'Review Pasien',
                  subtitle: embeddedInMainNav
                      ? 'Kelola daftar pasien yang terhubung dengan akun Anda.'
                      : 'Pantau pasien aktif, lakukan review data medis, dan lanjutkan edukasi.',
                  onBack: embeddedInMainNav
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
                const Gap(UiSpacing.sm),
                const Gap(UiSpacing.md),
                AconsiaCardSurface(
                  borderColor: const Color(0xFFDCEAFF),
                  padding: const EdgeInsets.all(UiSpacing.md),
                  child: pasienList.when(
                    data: (data) => Row(
                      children: [
                        const Icon(
                          Icons.groups_2_outlined,
                          color: UiPalette.blue600,
                        ),
                        const Gap(10),
                        Expanded(
                          child: Text(
                            '${data?.length ?? 0} pasien terhubung dengan akun dokter Anda.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF23415F),
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    loading: () => const Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        Gap(10),
                        Text(
                          'Memuat daftar pasien...',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF23415F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    error: (_, __) => const Row(
                      children: [
                        Icon(Icons.error_outline, color: UiPalette.red600),
                        Gap(10),
                        Text(
                          'Gagal memuat jumlah pasien.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF23415F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(UiSpacing.md),
                Wrap(
                  spacing: UiSpacing.sm,
                  runSpacing: UiSpacing.xs,
                  children: [
                    _buildFilterChip(
                      label: 'Semua',
                      selected: filterMode.value == _ReviewFilter.all,
                      onSelected: () => filterMode.value = _ReviewFilter.all,
                    ),
                    _buildFilterChip(
                      label: 'Menunggu Review',
                      selected: filterMode.value == _ReviewFilter.pending,
                      onSelected: () =>
                          filterMode.value = _ReviewFilter.pending,
                    ),
                    _buildFilterChip(
                      label: 'Siap Edukasi',
                      selected: filterMode.value == _ReviewFilter.ready,
                      onSelected: () => filterMode.value = _ReviewFilter.ready,
                    ),
                  ],
                ),
                const Gap(UiSpacing.sm),
                CustomSearchField(
                  hintText: 'Cari nama pasien / no rekam medis...',
                  controller: searchController,
                  onChanged: (value) {
                    searchQuery.value = value.trim().toLowerCase();
                  },
                ),
                const Gap(UiSpacing.xl),
                pasienList.when(
                  data: (data) {
                    final allData = data ?? [];
                    final filteredData = allData.where((pasien) {
                      if (searchQuery.value.isEmpty) return true;
                      final nama = (pasien.namaLengkap ?? '').toLowerCase();
                      final rm = (pasien.noRekamMedis ?? '').toLowerCase();
                      return nama.contains(searchQuery.value) ||
                          rm.contains(searchQuery.value);
                    }).toList();
                    final filteredByMode = filteredData.where((pasien) {
                      final status = _resolveReviewStatus(pasien);
                      final ready = status == 'ready' ||
                          status == 'approved' ||
                          status == 'in_progress' ||
                          status == 'completed';
                      switch (filterMode.value) {
                        case _ReviewFilter.all:
                          return status != 'rejected';
                        case _ReviewFilter.pending:
                          return status == 'pending';
                        case _ReviewFilter.ready:
                          return ready;
                      }
                    }).toList();

                    if (filteredByMode.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: UiSpacing.xxxl),
                          child: Column(
                            children: [
                              Icon(
                                searchQuery.value.isEmpty
                                    ? Icons.folder_off_outlined
                                    : Icons.search_off_outlined,
                                size: 54,
                                color: Colors.grey.shade500,
                              ),
                              const Gap(UiSpacing.sm),
                              Text(
                                searchQuery.value.isEmpty
                                    ? 'Belum ada pasien aktif.'
                                    : 'Tidak ada pasien yang cocok.',
                                style: TextStyle(
                                  color: UiPalette.slate500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredByMode.length,
                      separatorBuilder: (_, __) => const Gap(UiSpacing.md),
                      itemBuilder: (context, index) {
                        return ListPasienWidget(
                          pasien: filteredByMode[index],
                        );
                      },
                    );
                  },
                  error: (error, _) => Center(
                    child: Text('Error: $error'),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      selectedColor: UiPalette.blue100,
      checkmarkColor: UiPalette.blue600,
      backgroundColor: UiPalette.white,
      side: BorderSide(
        color: selected ? UiPalette.blue500 : UiPalette.slate300,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: TextStyle(
        fontSize: 12.5,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        color: selected ? UiPalette.blue600 : const Color(0xFF41556F),
      ),
    );
  }

  String _resolveReviewStatus(PasienProfileModel pasien) {
    final preOp = pasien.preOperativeAssessment ?? const <String, dynamic>{};
    final rawStatus = (preOp['status'] as String? ?? '').trim().toLowerCase();
    if (rawStatus == 'rejected') return 'rejected';
    if (rawStatus == 'pending') return 'pending';
    if (rawStatus == 'approved' ||
        rawStatus == 'in_progress' ||
        rawStatus == 'ready' ||
        rawStatus == 'completed') {
      return rawStatus;
    }

    final operasi = (pasien.jenisOperasi ?? '').trim();
    final anestesi = (pasien.jenisAnestesi ?? '').trim();
    final asa = (pasien.klasifikasiAsa ?? '').trim();
    final medicalReady =
        operasi.isNotEmpty && anestesi.isNotEmpty && asa.isNotEmpty;
    if (!medicalReady) return 'pending';
    return 'approved';
  }
}

enum _ReviewFilter { all, pending, ready }

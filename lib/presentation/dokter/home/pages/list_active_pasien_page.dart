import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_search_field.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_list_by_dokter_id/fetch_pasien_list_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/widgets/list_pasien_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListActivePasienPage extends HookConsumerWidget {
  const ListActivePasienPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final filterMode = useState(_ReviewFilter.all);

    final pasienList =
        ref.watch(fetchPasienListByDokterIdProvider(dokterId: uid ?? ''));

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Kembali',
        centertitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFFAF3),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchPasienListByDokterIdProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Pasien',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                Text(
                  'Pantau pasien aktif dan lanjutkan review data medis dengan cepat.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.textGrayColor,
                  ),
                ),
                const Gap(16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDCEAFF)),
                  ),
                  child: pasienList.when(
                    data: (data) => Row(
                      children: [
                        const Icon(
                          Icons.groups_2_outlined,
                          color: AppColor.primaryColor,
                        ),
                        const Gap(10),
                        Expanded(
                          child: Text(
                            '${data?.length ?? 0} pasien terhubung dengan akun dokter Anda.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF23415F),
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
                        Icon(Icons.error_outline, color: AppColor.primaryRed),
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
                const Gap(16),
                Row(
                  children: [
                    _buildFilterChip(
                      label: 'Semua',
                      selected: filterMode.value == _ReviewFilter.all,
                      onSelected: () => filterMode.value = _ReviewFilter.all,
                    ),
                    const Gap(8),
                    _buildFilterChip(
                      label: 'Menunggu Review',
                      selected: filterMode.value == _ReviewFilter.pending,
                      onSelected: () => filterMode.value = _ReviewFilter.pending,
                    ),
                    const Gap(8),
                    _buildFilterChip(
                      label: 'Siap Edukasi',
                      selected: filterMode.value == _ReviewFilter.ready,
                      onSelected: () => filterMode.value = _ReviewFilter.ready,
                    ),
                  ],
                ),
                const Gap(14),
                CustomSearchField(
                  hintText: 'Cari nama pasien / no rekam medis...',
                  controller: searchController,
                  onChanged: (value) {
                    searchQuery.value = value.trim().toLowerCase();
                  },
                ),
                const Gap(24),
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
                      final ready = _isMedicalReady(pasien);
                      switch (filterMode.value) {
                        case _ReviewFilter.all:
                          return true;
                        case _ReviewFilter.pending:
                          return !ready;
                        case _ReviewFilter.ready:
                          return ready;
                      }
                    }).toList();

                    if (filteredByMode.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: Column(
                            children: [
                              Icon(
                                searchQuery.value.isEmpty
                                    ? Icons.folder_off_outlined
                                    : Icons.search_off_outlined,
                                size: 54,
                                color: Colors.grey.shade500,
                              ),
                              const Gap(10),
                              Text(
                                searchQuery.value.isEmpty
                                    ? 'Belum ada pasien aktif.'
                                    : 'Tidak ada pasien yang cocok.',
                                style: TextStyle(
                                  color: AppColor.textGrayColor,
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
                      separatorBuilder: (_, __) => const Gap(12),
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
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0EA5E9) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF0EA5E9) : const Color(0xFFDCE7F5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF41556F),
          ),
        ),
      ),
    );
  }

  bool _isMedicalReady(PasienProfileModel pasien) {
    final operasi = (pasien.jenisOperasi ?? '').trim();
    final anestesi = (pasien.jenisAnestesi ?? '').trim();
    final asa = (pasien.klasifikasiAsa ?? '').trim();
    return operasi.isNotEmpty && anestesi.isNotEmpty && asa.isNotEmpty;
  }
}

enum _ReviewFilter { all, pending, ready }

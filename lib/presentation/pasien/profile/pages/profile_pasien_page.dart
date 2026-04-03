import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_learning_summary_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_choose_dokter_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_contact_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_medic_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_personal_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_wali_information_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ProfilePasienPage extends HookConsumerWidget {
  const ProfilePasienPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dokterController = useTextEditingController();
    final namaController = useTextEditingController();
    final noRekamMedisController = useTextEditingController();
    final nikController = useTextEditingController();
    final tanggalLahirController = useTextEditingController();
    final jenisKelaminController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final jenisOperasiController = useTextEditingController();
    final jenisAnestesiController = useTextEditingController();
    final klasifikasiasaController = useTextEditingController();
    final tinggiBadanController = useTextEditingController();
    final beratBadanController = useTextEditingController();
    final namaWaliController = useTextEditingController();
    final hubunganController = useTextEditingController();
    final nomorHpController = useTextEditingController();
    final alamatController = useTextEditingController();

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final selectedTab = useState(_ProfileTab.info);

    final profilePasien =
        ref.watch(fetchPasienProfileProvider(pasienId: uid)).value;
    final dokterId = profilePasien?.dokterId ?? '';
    final learningSummaryAsync = uid.isNotEmpty && dokterId.isNotEmpty
        ? ref.watch(
            pasienLearningSummaryProvider(
              PasienLearningSummaryParams(
                pasienId: uid,
                dokterId: dokterId,
              ),
            ),
          )
        : const AsyncValue.data(PasienLearningSummary.empty());

    useEffect(() {
      if (profilePasien != null) {
        dokterController.text = profilePasien.dokterId ?? '';
        namaController.text = profilePasien.namaLengkap ?? '';
        noRekamMedisController.text = profilePasien.noRekamMedis ?? '';
        nikController.text = profilePasien.nik ?? '';
        tanggalLahirController.text = profilePasien.tanggalLahir != null
            ? DateFormat('d/M/yyyy').format(profilePasien.tanggalLahir!.toDate())
            : '';
        jenisKelaminController.text = profilePasien.jenisKelamin ?? '';
        emailController.text = profilePasien.email ?? '';
        phoneController.text = profilePasien.nomorTelepon ?? '';
        jenisOperasiController.text = profilePasien.jenisOperasi ?? '';
        jenisAnestesiController.text = profilePasien.jenisAnestesi ?? '';
        klasifikasiasaController.text = profilePasien.klasifikasiAsa ?? '';
        tinggiBadanController.text = profilePasien.tinggiBadan?.toString() ?? '';
        beratBadanController.text = profilePasien.beratBadan?.toString() ?? '';
        namaWaliController.text = profilePasien.namaWali ?? '';
        hubunganController.text = profilePasien.hubunganWali ?? '';
        nomorHpController.text = profilePasien.nomorHpWali ?? '';
        alamatController.text = profilePasien.alamatWali ?? '';
      }
      return null;
    }, [profilePasien]);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF2F8FF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchPasienProfileProvider);
            if (uid.isNotEmpty && dokterId.isNotEmpty) {
              ref.invalidate(
                pasienLearningSummaryProvider(
                  PasienLearningSummaryParams(
                    pasienId: uid,
                    dokterId: dokterId,
                  ),
                ),
              );
            }
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(16),
                  _buildHeader(
                    nama: namaController.text,
                    email: emailController.text,
                  ),
                  const Gap(14),
                  _buildTabSwitcher(
                    selectedTab: selectedTab.value,
                    onSelect: (tab) => selectedTab.value = tab,
                  ),
                  const Gap(16),
                  if (selectedTab.value == _ProfileTab.info) ...[
                    PasienChooseDokterWidget(dokterController: dokterController),
                    const Gap(16),
                    PasienPersonalInformationWidget(
                      namaController: namaController,
                      noRekamMedisController: noRekamMedisController,
                      nikController: nikController,
                      tanggalLahirController: tanggalLahirController,
                      jenisKelaminController: jenisKelaminController,
                    ),
                    const Gap(16),
                    PasienContactWidget(
                      emailController: emailController,
                      phoneController: phoneController,
                    ),
                    const Gap(16),
                    PasienMedicInformationWidget(
                      jenisOperasiController: jenisOperasiController,
                      jenisAnestesiController: jenisAnestesiController,
                      klasifikasiasaController: klasifikasiasaController,
                      tinggiBadanController: tinggiBadanController,
                      beratBadanController: beratBadanController,
                      isDokterInput: true,
                    ),
                    const Gap(16),
                    PasienWaliInformationWidget(
                      namaController: namaWaliController,
                      hubunganController: hubunganController,
                      nomorHpController: nomorHpController,
                      alamatController: alamatController,
                    ),
                  ] else ...[
                    _buildPerformaTab(learningSummaryAsync),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button.filled(
              onPressed: () => context.pushNamed(RouteName.editProfilePasien),
              label: 'Edit Data Diri',
            ),
            const Gap(12),
            Button.outlined(
              onPressed: () => context.showLogoutDialog(ref),
              label: 'Keluar',
              borderColor: AppColor.primaryRed,
              textColor: AppColor.primaryRed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({required String nama, required String email}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDCEAFF)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: const Color(0xFFE6F0FF),
            child: Text(
              (nama.isNotEmpty ? nama : 'Pasien').substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
          ),
          const Gap(10),
          Text(
            nama.isEmpty ? 'Pasien' : nama,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(4),
          Text(
            email,
            style: const TextStyle(
              fontSize: 13,
              color: AppColor.textGrayColor,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Role: Pasien',
              style: TextStyle(
                fontSize: 13,
                color: AppColor.primaryWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher({
    required _ProfileTab selectedTab,
    required void Function(_ProfileTab tab) onSelect,
  }) {
    Widget pill({
      required String text,
      required _ProfileTab tab,
    }) {
      final selected = selectedTab == tab;
      return Expanded(
        child: InkWell(
          onTap: () => onSelect(tab),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF0EA5E9) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? const Color(0xFF0EA5E9) : const Color(0xFFDCE7F5),
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : const Color(0xFF3E536C),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        pill(text: 'Informasi', tab: _ProfileTab.info),
        const Gap(8),
        pill(text: 'Performa', tab: _ProfileTab.performa),
      ],
    );
  }

  Widget _buildPerformaTab(AsyncValue<PasienLearningSummary> summaryAsync) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2EAF4)),
      ),
      child: summaryAsync.when(
        data: (summary) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Performa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF132A45),
                ),
              ),
              const Gap(8),
              Text(
                'Progress belajar dan hasil quiz terbaru Anda.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.textGrayColor,
                ),
              ),
              const Gap(14),
              Row(
                children: [
                  Expanded(
                    child: _metric(
                      title: 'Progress',
                      value: '${summary.completionRate.toStringAsFixed(0)}%',
                      color: const Color(0xFF0EA5E9),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: _metric(
                      title: 'Materi Selesai',
                      value: '${summary.completedKonten}',
                      color: const Color(0xFF22C35D),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: _metric(
                      title: 'Belum Selesai',
                      value: '${summary.unreadKonten}',
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: _metric(
                      title: 'Rata-rata Quiz',
                      value: '${summary.averageQuizScore.toStringAsFixed(0)}%',
                      color: const Color(0xFF7C3AED),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              if (summary.latestQuiz == null)
                Text(
                  'Belum ada hasil quiz. Lanjutkan pembelajaran untuk melihat insight lebih detail.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.textGrayColor,
                  ),
                )
              else
                Text(
                  'Quiz terakhir: ${summary.latestQuiz!.overallScore}% • ${summary.latestQuiz!.status}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF51657D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Text(
          'Gagal memuat performa: $error',
          style: const TextStyle(
            color: AppColor.primaryRed,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _metric({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF5F748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

enum _ProfileTab { info, performa }

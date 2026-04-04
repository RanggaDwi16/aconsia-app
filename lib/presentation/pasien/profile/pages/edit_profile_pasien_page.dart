import 'package:aconsia_app/core/helpers/timestamp/timestamp_convert.dart';
import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/update_pasien_profile/patch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/quiz/controllers/quiz_result_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_choose_dokter_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_contact_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_medic_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_personal_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_wali_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EditProfilePasienPage extends HookConsumerWidget {
  const EditProfilePasienPage({super.key});

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

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final profilePasien =
        ref.watch(fetchPasienProfileProvider(pasienId: uid ?? ''));

    final patchPasienProfileState = ref.watch(patchPasienProfileProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authenticationProvider.notifier).getCurrentUser(
          onSuccess: (user) {
            namaController.text = user.name ?? '';
            emailController.text = user.email;
          },
          onError: (err) {
            context.showErrorSnackbar(context, err);
          },
        );
      });

      profilePasien.whenData((pasienProfile) {
        if (pasienProfile != null) {
          dokterController.text = pasienProfile.dokterId ?? '';
          namaController.text = pasienProfile.namaLengkap ?? '';
          noRekamMedisController.text = pasienProfile.noRekamMedis ?? '';
          nikController.text = pasienProfile.nik ?? '';
          tanggalLahirController.text = pasienProfile.tanggalLahir != null
              ? DateFormat('d/M/yyyy')
                  .format(pasienProfile.tanggalLahir!.toDate())
              : '';

          jenisKelaminController.text = pasienProfile.jenisKelamin ?? '';
          emailController.text = pasienProfile.email ?? '';
          phoneController.text = pasienProfile.nomorTelepon ?? '';
          jenisOperasiController.text = pasienProfile.jenisOperasi ?? '';
          jenisAnestesiController.text = pasienProfile.jenisAnestesi ?? '';
          klasifikasiasaController.text = pasienProfile.klasifikasiAsa ?? '';
          tinggiBadanController.text =
              pasienProfile.tinggiBadan?.toString() ?? '';
          beratBadanController.text =
              pasienProfile.beratBadan?.toString() ?? '';
          namaWaliController.text = pasienProfile.namaWali ?? '';
          hubunganController.text = pasienProfile.hubunganWali ?? '';
          nomorHpController.text = pasienProfile.nomorHpWali ?? '';
          alamatController.text = pasienProfile.alamatWali ?? '';
        } else {}
      });

      return null;
    }, [profilePasien]);

    useListenable(dokterController);
    useListenable(namaController);
    useListenable(noRekamMedisController);
    useListenable(nikController);
    useListenable(tanggalLahirController);
    useListenable(jenisKelaminController);
    useListenable(emailController);
    useListenable(phoneController);
    // useListenable(jenisOperasiController);
    // useListenable(jenisAnestesiController);
    // useListenable(klasifikasiasaController);
    useListenable(tinggiBadanController);
    useListenable(beratBadanController);
    useListenable(namaWaliController);
    useListenable(hubunganController);
    useListenable(nomorHpController);
    useListenable(alamatController);
    final allFieldsEmpty = dokterController.text.isEmpty ||
        namaController.text.isEmpty ||
        noRekamMedisController.text.isEmpty ||
        nikController.text.isEmpty ||
        tanggalLahirController.text.isEmpty ||
        jenisKelaminController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        // jenisOperasiController.text.isEmpty ||
        // jenisAnestesiController.text.isEmpty ||
        // klasifikasiasaController.text.isEmpty ||
        tinggiBadanController.text.isEmpty ||
        beratBadanController.text.isEmpty ||
        namaWaliController.text.isEmpty ||
        hubunganController.text.isEmpty ||
        nomorHpController.text.isEmpty ||
        alamatController.text.isEmpty;

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [UiPalette.blue50, UiPalette.white],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AconsiaTopActionRow(
                  title: 'Edit Profil Pasien',
                  subtitle: 'Perbarui data profil pasien',
                  onBack: () => context.pop(),
                ),
                const Gap(12),
                const AconsiaInfoBanner(
                  icon: Icons.person_outline,
                  message:
                      'Pastikan data profil sesuai agar rekomendasi dan pendampingan dokter lebih akurat.',
                  backgroundColor: UiPalette.blue50,
                  borderColor: UiPalette.blue100,
                  iconColor: UiPalette.blue600,
                  textColor: UiPalette.slate700,
                ),
                const Gap(12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFDCEAFF)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        namaController.text.isEmpty ? 'Pasien' : namaController.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: UiPalette.blue600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Perbarui data profil pasien',
                          style: TextStyle(
                            fontSize: 12,
                            color: UiPalette.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                PasienChooseDokterWidget(
                  dokterController: dokterController,
                  isEditable: true,
                ),
                const Gap(24),
                PasienPersonalInformationWidget(
                  isEditable: true,
                  namaController: namaController,
                  noRekamMedisController: noRekamMedisController,
                  nikController: nikController,
                  tanggalLahirController: tanggalLahirController,
                  jenisKelaminController: jenisKelaminController,
                ),
                const Gap(16),
                PasienContactWidget(
                  isEditable: true,
                  emailController: emailController,
                  phoneController: phoneController,
                ),
                const Gap(16),
                PasienMedicInformationWidget(
                  isEditable: true,
                  jenisOperasiController: jenisOperasiController,
                  jenisAnestesiController: jenisAnestesiController,
                  klasifikasiasaController: klasifikasiasaController,
                  tinggiBadanController: tinggiBadanController,
                  beratBadanController: beratBadanController,
                  isDokterInput: false,
                ),
                const Gap(16),
                PasienWaliInformationWidget(
                  isEditable: true,
                  namaController: namaWaliController,
                  hubunganController: hubunganController,
                  nomorHpController: nomorHpController,
                  alamatController: alamatController,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Button.filled(
          disabled: allFieldsEmpty || patchPasienProfileState.isLoading,
          onPressed: () {
            ref.read(patchPasienProfileProvider.notifier).patchPasienProfile(
                  pasienProfile: PasienProfileModel(
                    uid: uid!,
                    dokterId: dokterController.text,
                    namaLengkap: namaController.text,
                    noRekamMedis: noRekamMedisController.text,
                    nik: nikController.text,
                    tanggalLahir: tryParseTanggal(tanggalLahirController.text),
                    jenisKelamin: jenisKelaminController.text,
                    email: emailController.text,
                    nomorTelepon: phoneController.text,
                    jenisOperasi: jenisOperasiController.text,
                    jenisAnestesi: jenisAnestesiController.text,
                    klasifikasiAsa: klasifikasiasaController.text,
                    tinggiBadan: double.tryParse(tinggiBadanController.text),
                    beratBadan: double.tryParse(beratBadanController.text),
                    namaWali: namaWaliController.text,
                    hubunganWali: hubunganController.text,
                    nomorHpWali: nomorHpController.text,
                    alamatWali: alamatController.text,
                  ),
                  onSuccess: (message) {
                    ref
                        .read(authenticationProvider.notifier)
                        .updateProfileCompleted(
                          uid: uid,
                          isCompleted: true,
                          onSuccess: (message) {
                            context.showSuccessDialog(context, message);
                            ref.invalidate(fetchPasienProfileProvider);
                            ref.invalidate(fetchKontenByDokterIdProvider);
                            ref.invalidate(fetchQuizResultByKontenProvider);
                            context.goNamed(RouteName.mainPasien);
                          },
                          onError: (error) {
                            context.showErrorSnackbar(context, error);
                          },
                        );
                  },
                  onError: (error) {
                    context.showErrorSnackbar(context, error);
                  },
                );
          },
          label: patchPasienProfileState.isLoading
              ? 'Menyimpan...'
              : 'Simpan Perubahan',
          height: 48,
          borderRadius: 12,
        ),
      ),
    );
  }
}

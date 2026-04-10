import 'package:aconsia_app/core/helpers/timestamp/timestamp_convert.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_dropdown.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/providers/token_manager_provider.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_all_dokter_options/fetch_all_dokter_options_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/update_pasien_profile/patch_pasien_profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final passwordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final confirmPasswordVisibleProvider =
    StateProvider.autoDispose<bool>((ref) => false);

const _emailPattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';

enum _RegisterStep { akun, identitas, medis, riwayat, dokter }

class RegisterPasienPage extends HookConsumerWidget {
  const RegisterPasienPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState<int>(0);
    final isSubmitting = useState<bool>(false);
    final registeredUid = useState<String?>(null);

    final namaController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final nikController = useTextEditingController();
    final tanggalLahirController = useTextEditingController();
    final umurController = useTextEditingController();
    final jenisKelaminController = useTextEditingController();
    final agamaController = useTextEditingController();
    final statusPernikahanController = useTextEditingController();
    final pendidikanTerakhirController = useTextEditingController();
    final pekerjaanController = useTextEditingController();
    final alamatLengkapController = useTextEditingController();
    final rtController = useTextEditingController();
    final rwController = useTextEditingController();
    final kelurahanDesaController = useTextEditingController();
    final kecamatanController = useTextEditingController();
    final kotaKabupatenController = useTextEditingController();
    final provinsiController = useTextEditingController();

    final noRekamMedisController = useTextEditingController();
    final nomorTeleponController = useTextEditingController();
    final namaWaliController = useTextEditingController();
    final hubunganWaliController = useTextEditingController();
    final nomorHpWaliController = useTextEditingController();
    final alamatWaliController = useTextEditingController();

    final dokterController = useTextEditingController();

    final isPasswordVisible = ref.watch(passwordVisibleProvider);
    final isConfirmPasswordVisible = ref.watch(confirmPasswordVisibleProvider);
    final auth = ref.watch(authenticationProvider);
    final allDokter = ref.watch(fetchAllDokterOptionsProvider);
    final patchState = ref.watch(patchPasienProfileProvider);

    useListenable(namaController);
    useListenable(emailController);
    useListenable(passwordController);
    useListenable(confirmPasswordController);
    useListenable(nikController);
    useListenable(tanggalLahirController);
    useListenable(umurController);
    useListenable(jenisKelaminController);
    useListenable(agamaController);
    useListenable(statusPernikahanController);
    useListenable(pendidikanTerakhirController);
    useListenable(pekerjaanController);
    useListenable(alamatLengkapController);
    useListenable(rtController);
    useListenable(rwController);
    useListenable(kelurahanDesaController);
    useListenable(kecamatanController);
    useListenable(kotaKabupatenController);
    useListenable(provinsiController);
    useListenable(noRekamMedisController);
    useListenable(nomorTeleponController);
    useListenable(namaWaliController);
    useListenable(hubunganWaliController);
    useListenable(nomorHpWaliController);
    useListenable(alamatWaliController);
    useListenable(dokterController);

    void updateUmurFromTanggalLahir(String rawTanggal) {
      final timestamp = tryParseTanggal(rawTanggal);
      if (timestamp == null) {
        umurController.text = '';
        return;
      }
      final birthDate = timestamp.toDate();
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      final hasBirthdayPassed = now.month > birthDate.month ||
          (now.month == birthDate.month && now.day >= birthDate.day);
      if (!hasBirthdayPassed) age -= 1;
      umurController.text = age < 0 ? '' : '$age tahun';
    }

    bool isValidEmail(String value) {
      return RegExp(_emailPattern).hasMatch(value.trim());
    }

    bool isValidPhone(String value, {int minLength = 10}) {
      final raw = value.trim();
      return RegExp(r'^\d+$').hasMatch(raw) && raw.length >= minLength;
    }

    bool validateStep(int step) {
      if (step == _RegisterStep.akun.index) {
        final nama = namaController.text.trim();
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        final confirmPassword = confirmPasswordController.text.trim();

        if (nama.isEmpty) {
          context.showErrorSnackbar(context, 'Nama lengkap wajib diisi.');
          return false;
        }
        if (email.isEmpty || !isValidEmail(email)) {
          context.showErrorSnackbar(
              context, 'Email wajib diisi dengan format valid.');
          return false;
        }
        if (password.length < 6) {
          context.showErrorSnackbar(context, 'Password minimal 6 karakter.');
          return false;
        }
        if (password != confirmPassword) {
          context.showErrorSnackbar(context, 'Konfirmasi password tidak sama.');
          return false;
        }
        return true;
      }

      if (step == _RegisterStep.identitas.index) {
        final nik = nikController.text.trim();
        if (nik.length != 16) {
          context.showErrorSnackbar(context, 'NIK wajib 16 digit.');
          return false;
        }
        if (tanggalLahirController.text.trim().isEmpty ||
            tryParseTanggal(tanggalLahirController.text.trim()) == null) {
          context.showErrorSnackbar(
              context, 'Tanggal lahir wajib diisi dengan format valid.');
          return false;
        }
        if (jenisKelaminController.text.trim().isEmpty) {
          context.showErrorSnackbar(context, 'Jenis kelamin wajib dipilih.');
          return false;
        }
        if (agamaController.text.trim().isEmpty) {
          context.showErrorSnackbar(context, 'Agama wajib dipilih.');
          return false;
        }
        if (statusPernikahanController.text.trim().isEmpty) {
          context.showErrorSnackbar(
              context, 'Status pernikahan wajib dipilih.');
          return false;
        }
        if (pendidikanTerakhirController.text.trim().isEmpty) {
          context.showErrorSnackbar(
              context, 'Pendidikan terakhir wajib diisi.');
          return false;
        }
        if (pekerjaanController.text.trim().isEmpty) {
          context.showErrorSnackbar(context, 'Pekerjaan wajib diisi.');
          return false;
        }
        if (!isValidPhone(nomorTeleponController.text, minLength: 10)) {
          context.showErrorSnackbar(
              context, 'No. telepon wajib angka dan minimal 10 digit.');
          return false;
        }
        if (alamatLengkapController.text.trim().isEmpty) {
          context.showErrorSnackbar(context, 'Alamat lengkap wajib diisi.');
          return false;
        }
        if (!RegExp(r'^\d{1,3}$').hasMatch(rtController.text.trim())) {
          context.showErrorSnackbar(
              context, 'RT wajib angka dengan panjang 1 sampai 3 digit.');
          return false;
        }
        if (!RegExp(r'^\d{1,3}$').hasMatch(rwController.text.trim())) {
          context.showErrorSnackbar(
              context, 'RW wajib angka dengan panjang 1 sampai 3 digit.');
          return false;
        }
        if (kelurahanDesaController.text.trim().isEmpty ||
            kecamatanController.text.trim().isEmpty ||
            kotaKabupatenController.text.trim().isEmpty ||
            provinsiController.text.trim().isEmpty) {
          context.showErrorSnackbar(
              context, 'Data wilayah domisili wajib dilengkapi.');
          return false;
        }
        return true;
      }

      if (step == _RegisterStep.riwayat.index) {
        if (namaWaliController.text.trim().isEmpty ||
            hubunganWaliController.text.trim().isEmpty ||
            !isValidPhone(nomorHpWaliController.text, minLength: 10) ||
            alamatWaliController.text.trim().isEmpty) {
          context.showErrorSnackbar(
              context, 'Data penanggung jawab wajib dilengkapi dengan benar.');
          return false;
        }
        return true;
      }

      if (step == _RegisterStep.dokter.index) {
        if (dokterController.text.trim().isEmpty) {
          context.showErrorSnackbar(
              context, 'Silakan pilih dokter pendamping.');
          return false;
        }
        return true;
      }

      return true;
    }

    Future<void> handleSubmit() async {
      if (!validateStep(_RegisterStep.akun.index) ||
          !validateStep(_RegisterStep.identitas.index) ||
          !validateStep(_RegisterStep.riwayat.index) ||
          !validateStep(_RegisterStep.dokter.index)) {
        return;
      }
      if (isSubmitting.value || auth.isLoading || patchState.isLoading) {
        return;
      }

      isSubmitting.value = true;
      final email = emailController.text.trim();
      final nama = namaController.text.trim();
      Future<void> continueProfileSubmit(String uid) async {
        registeredUid.value = uid;
        ref.read(patchPasienProfileProvider.notifier).patchPasienProfile(
              pasienProfile: PasienProfileModel(
                uid: uid,
                dokterId: dokterController.text.trim(),
                namaLengkap: nama,
                nomorTelepon: nomorTeleponController.text.trim(),
                email: email,
                noRekamMedis: noRekamMedisController.text.trim(),
                nik: nikController.text.trim(),
                tanggalLahir:
                    tryParseTanggal(tanggalLahirController.text.trim()),
                jenisKelamin: jenisKelaminController.text.trim(),
                agama: agamaController.text.trim(),
                statusPernikahan: statusPernikahanController.text.trim(),
                pendidikanTerakhir: pendidikanTerakhirController.text.trim(),
                pekerjaan: pekerjaanController.text.trim(),
                alamatLengkap: alamatLengkapController.text.trim(),
                rt: rtController.text.trim(),
                rw: rwController.text.trim(),
                kelurahanDesa: kelurahanDesaController.text.trim(),
                kecamatan: kecamatanController.text.trim(),
                kotaKabupaten: kotaKabupatenController.text.trim(),
                provinsi: provinsiController.text.trim(),
                jenisOperasi: null,
                jenisAnestesi: null,
                klasifikasiAsa: null,
                tinggiBadan: null,
                beratBadan: null,
                namaWali: namaWaliController.text.trim(),
                hubunganWali: hubunganWaliController.text.trim(),
                nomorHpWali: nomorHpWaliController.text.trim(),
                alamatWali: alamatWaliController.text.trim(),
                createdAt: Timestamp.now(),
              ),
              onSuccess: (_) {
                ref
                    .read(authenticationProvider.notifier)
                    .updateProfileCompleted(
                      uid: uid,
                      isCompleted: true,
                      onSuccess: (_) async {
                        final tokenManager =
                            await ref.read(tokenManagerProvider.future);
                        await tokenManager.saveUserSession(
                          uid: uid,
                          email: email,
                          name: nama,
                          role: 'pasien',
                          isProfileCompleted: true,
                        );
                        if (!context.mounted) return;
                        isSubmitting.value = false;
                        context.showSuccessDialog(
                            context, 'Pendaftaran pasien berhasil.');
                        context.goNamed(RouteName.mainPasien);
                      },
                      onError: (error) {
                        isSubmitting.value = false;
                        context.showErrorSnackbar(context, error);
                      },
                    );
              },
              onError: (error) {
                isSubmitting.value = false;
                final lower = error.toLowerCase();
                final friendly = lower.contains('permission-denied')
                    ? 'Akses pasien belum sinkron. Silakan logout-login lalu coba lagi.'
                    : error;
                context.showErrorSnackbar(context, friendly);
              },
            );
      }

      final existingUid = registeredUid.value;
      if (existingUid != null && existingUid.isNotEmpty) {
        await continueProfileSubmit(existingUid);
        return;
      }

      ref.read(authenticationProvider.notifier).registerPasien(
            email: email,
            password: passwordController.text.trim(),
            name: nama,
            onSuccess: (_) async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null || uid.isEmpty) {
                isSubmitting.value = false;
                context.showErrorSnackbar(
                  context,
                  'Akun berhasil dibuat, tetapi UID tidak ditemukan. Silakan login ulang.',
                );
                return;
              }
              await continueProfileSubmit(uid);
            },
            onError: (error) {
              isSubmitting.value = false;
              context.showErrorSnackbar(context, error);
            },
          );
    }

    void goNextStep() {
      if (!validateStep(currentStep.value)) return;
      if (currentStep.value < _RegisterStep.values.length - 1) {
        currentStep.value += 1;
      }
    }

    void goPrevStep() {
      if (currentStep.value > 0) {
        currentStep.value -= 1;
      }
    }

    final stepLabels = const [
      'Akun',
      'Identitas',
      'Data Medis',
      'Riwayat',
      'Dokter'
    ];
    final isLastStep = currentStep.value == _RegisterStep.values.length - 1;

    return Scaffold(
      body: AconsiaScreenShell(
        colors: const [UiPalette.blue50, UiPalette.white],
        top: AconsiaTopActionRow(
          title: 'Formulir Pendaftaran Pasien',
          subtitle:
              'Lengkapi data diri Anda. Data medis akan diisi dokter setelah pendaftaran.',
          onBack: () => context.pop(),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AconsiaCardSurface(
                  radius: 16,
                  borderColor: const Color(0xFFDCEAFF),
                  padding: const EdgeInsets.all(UiSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStepper(
                        labels: stepLabels,
                        currentStep: currentStep.value,
                      ),
                      const Gap(UiSpacing.lg),
                      _buildStepCardHeader(
                        title:
                            _stepTitle(_RegisterStep.values[currentStep.value]),
                        subtitle: _stepSubtitle(
                            _RegisterStep.values[currentStep.value]),
                      ),
                      const Gap(UiSpacing.md),
                      _buildStepContent(
                        context: context,
                        ref: ref,
                        step: _RegisterStep.values[currentStep.value],
                        isPasswordVisible: isPasswordVisible,
                        isConfirmPasswordVisible: isConfirmPasswordVisible,
                        namaController: namaController,
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                        nikController: nikController,
                        tanggalLahirController: tanggalLahirController,
                        umurController: umurController,
                        jenisKelaminController: jenisKelaminController,
                        agamaController: agamaController,
                        statusPernikahanController: statusPernikahanController,
                        pendidikanTerakhirController:
                            pendidikanTerakhirController,
                        pekerjaanController: pekerjaanController,
                        alamatLengkapController: alamatLengkapController,
                        rtController: rtController,
                        rwController: rwController,
                        kelurahanDesaController: kelurahanDesaController,
                        kecamatanController: kecamatanController,
                        kotaKabupatenController: kotaKabupatenController,
                        provinsiController: provinsiController,
                        noRekamMedisController: noRekamMedisController,
                        nomorTeleponController: nomorTeleponController,
                        namaWaliController: namaWaliController,
                        hubunganWaliController: hubunganWaliController,
                        nomorHpWaliController: nomorHpWaliController,
                        alamatWaliController: alamatWaliController,
                        dokterController: dokterController,
                        allDokter: allDokter,
                        onPasswordToggle: () => ref
                            .read(passwordVisibleProvider.notifier)
                            .update((s) => !s),
                        onConfirmPasswordToggle: () => ref
                            .read(confirmPasswordVisibleProvider.notifier)
                            .update((s) => !s),
                        onTanggalLahirChanged: updateUmurFromTanggalLahir,
                      ),
                      const Gap(UiSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: Button.outlined(
                              onPressed: goPrevStep,
                              label: 'Kembali',
                              disabled:
                                  currentStep.value == 0 || isSubmitting.value,
                              borderColor: UiPalette.slate300,
                              textColor: UiPalette.slate700,
                            ),
                          ),
                          const Gap(UiSpacing.sm),
                          Expanded(
                            child: Button.filled(
                              onPressed: isLastStep ? handleSubmit : goNextStep,
                              disabled: isSubmitting.value ||
                                  auth.isLoading ||
                                  patchState.isLoading,
                              label: isSubmitting.value ||
                                      auth.isLoading ||
                                      patchState.isLoading
                                  ? 'Memproses...'
                                  : isLastStep
                                      ? 'Daftar'
                                      : 'Lanjut',
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
        ),
      ),
    );
  }

  Widget _buildStepper(
      {required List<String> labels, required int currentStep}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(labels.length, (index) {
          final isActive = currentStep == index;
          final isCompleted = index < currentStep;
          final color =
              isActive || isCompleted ? UiPalette.blue600 : UiPalette.slate300;

          return Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: UiTypography.button.copyWith(
                          color: UiPalette.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Gap(6),
                  SizedBox(
                    width: 84,
                    child: Text(
                      labels[index],
                      style: UiTypography.caption.copyWith(
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color:
                            isActive ? UiPalette.slate900 : UiPalette.slate500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              if (index != labels.length - 1)
                Container(
                  width: 28,
                  height: 2,
                  color: index < currentStep
                      ? UiPalette.blue600
                      : UiPalette.slate200,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepCardHeader(
      {required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAFF),
        border: Border.all(color: const Color(0xFFDCEAFF)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: UiTypography.title.copyWith(fontSize: 18),
          ),
          const Gap(4),
          Text(
            subtitle,
            style: UiTypography.bodySmall.copyWith(color: UiPalette.slate600),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent({
    required BuildContext context,
    required WidgetRef ref,
    required _RegisterStep step,
    required bool isPasswordVisible,
    required bool isConfirmPasswordVisible,
    required TextEditingController namaController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required TextEditingController nikController,
    required TextEditingController tanggalLahirController,
    required TextEditingController umurController,
    required TextEditingController jenisKelaminController,
    required TextEditingController agamaController,
    required TextEditingController statusPernikahanController,
    required TextEditingController pendidikanTerakhirController,
    required TextEditingController pekerjaanController,
    required TextEditingController alamatLengkapController,
    required TextEditingController rtController,
    required TextEditingController rwController,
    required TextEditingController kelurahanDesaController,
    required TextEditingController kecamatanController,
    required TextEditingController kotaKabupatenController,
    required TextEditingController provinsiController,
    required TextEditingController noRekamMedisController,
    required TextEditingController nomorTeleponController,
    required TextEditingController namaWaliController,
    required TextEditingController hubunganWaliController,
    required TextEditingController nomorHpWaliController,
    required TextEditingController alamatWaliController,
    required TextEditingController dokterController,
    required AsyncValue<List<DokterProfileModel>> allDokter,
    required VoidCallback onPasswordToggle,
    required VoidCallback onConfirmPasswordToggle,
    required ValueChanged<String> onTanggalLahirChanged,
  }) {
    if (step == _RegisterStep.akun) {
      return Column(
        children: [
          CustomTextField(
            controller: namaController,
            hintText: 'Nama sesuai KTP',
            labelText: 'Nama Lengkap',
            isRequired: true,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: emailController,
            hintText: 'alamat@email.com',
            labelText: 'Email',
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: passwordController,
            hintText: 'Minimal 6 karakter',
            labelText: 'Password',
            isRequired: true,
            obscureText: !isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: onPasswordToggle,
            ),
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: confirmPasswordController,
            hintText: 'Ulangi password',
            labelText: 'Konfirmasi Password',
            isRequired: true,
            obscureText: !isConfirmPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: onConfirmPasswordToggle,
            ),
          ),
        ],
      );
    }

    if (step == _RegisterStep.identitas) {
      Widget pairFields({
        required BuildContext context,
        required Widget left,
        required Widget right,
      }) {
        final isWide = MediaQuery.sizeOf(context).width >= 720;
        if (isWide) {
          return Row(
            children: [
              Expanded(child: left),
              const Gap(UiSpacing.md),
              Expanded(child: right),
            ],
          );
        }
        return Column(
          children: [
            left,
            const Gap(UiSpacing.md),
            right,
          ],
        );
      }

      return Column(
        children: [
          CustomTextField(
            controller: nikController,
            hintText: '16 digit NIK',
            labelText: 'NIK',
            isRequired: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: namaController,
            hintText: 'Nama sesuai KTP',
            labelText: 'Nama Lengkap',
            isRequired: true,
          ),
          const Gap(UiSpacing.md),
          pairFields(
            context: context,
            left: CustomTextField(
              controller: tanggalLahirController,
              hintText: 'dd/mm/yyyy',
              labelText: 'Tanggal Lahir',
              isRequired: true,
              isCalendar: true,
              suffixIcon: const Icon(Icons.calendar_month_outlined),
              onChanged: onTanggalLahirChanged,
            ),
            right: CustomTextField(
              controller: umurController,
              hintText: 'Otomatis dari tanggal lahir',
              labelText: 'Umur',
              isDisabled: true,
            ),
          ),
          const Gap(UiSpacing.md),
          pairFields(
            context: context,
            left: CustomDropdown(
              title: 'Jenis Kelamin',
              isRequired: true,
              items: const ['Laki-laki', 'Perempuan'],
              selectedValue: jenisKelaminController.text.isEmpty
                  ? null
                  : jenisKelaminController.text,
              onChanged: (value) => jenisKelaminController.text = value,
            ),
            right: CustomDropdown(
              title: 'Agama',
              isRequired: true,
              items: const [
                'Islam',
                'Kristen',
                'Katolik',
                'Hindu',
                'Buddha',
                'Konghucu',
                'Lainnya',
              ],
              selectedValue:
                  agamaController.text.isEmpty ? null : agamaController.text,
              onChanged: (value) => agamaController.text = value,
            ),
          ),
          const Gap(UiSpacing.md),
          pairFields(
            context: context,
            left: CustomDropdown(
              title: 'Status Pernikahan',
              isRequired: true,
              items: const [
                'Belum Menikah',
                'Menikah',
                'Cerai Hidup',
                'Cerai Mati',
              ],
              selectedValue: statusPernikahanController.text.isEmpty
                  ? null
                  : statusPernikahanController.text,
              onChanged: (value) => statusPernikahanController.text = value,
            ),
            right: CustomTextField(
              controller: pendidikanTerakhirController,
              hintText: 'SD, SMP, SMA, S1, dll',
              labelText: 'Pendidikan Terakhir',
              isRequired: true,
            ),
          ),
          const Gap(UiSpacing.md),
          pairFields(
            context: context,
            left: CustomTextField(
              controller: pekerjaanController,
              hintText: 'Pegawai, Wiraswasta, dll',
              labelText: 'Pekerjaan',
              isRequired: true,
            ),
            right: CustomTextField(
              controller: nomorTeleponController,
              hintText: '08xxxxxxxxxx',
              labelText: 'No. Telepon',
              isRequired: true,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
            ),
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: emailController,
            hintText: 'Email akun',
            labelText: 'Email',
            isDisabled: true,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: alamatLengkapController,
            hintText: 'Jalan, nomor rumah',
            labelText: 'Alamat Lengkap',
            isRequired: true,
            maxLines: 3,
          ),
          const Gap(UiSpacing.md),
          pairFields(
            context: context,
            left: CustomTextField(
              controller: rtController,
              hintText: '001',
              labelText: 'RT',
              isRequired: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
            right: CustomTextField(
              controller: rwController,
              hintText: '002',
              labelText: 'RW',
              isRequired: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
          ),
          const Gap(UiSpacing.md),
          pairFields(
            context: context,
            left: CustomTextField(
              controller: kelurahanDesaController,
              hintText: 'Kelurahan/Desa',
              labelText: 'Kelurahan/Desa',
              isRequired: true,
            ),
            right: CustomTextField(
              controller: kecamatanController,
              hintText: 'Kecamatan',
              labelText: 'Kecamatan',
              isRequired: true,
            ),
          ),
          const Gap(UiSpacing.md),
          pairFields(
            context: context,
            left: CustomTextField(
              controller: kotaKabupatenController,
              hintText: 'Kota/Kabupaten',
              labelText: 'Kota/Kabupaten',
              isRequired: true,
            ),
            right: CustomTextField(
              controller: provinsiController,
              hintText: 'Provinsi',
              labelText: 'Provinsi',
              isRequired: true,
            ),
          ),
        ],
      );
    }

    if (step == _RegisterStep.medis) {
      Widget readOnlyField(String label, String value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: UiTypography.label),
            const Gap(UiSpacing.xs),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: UiPalette.slate100,
                border: Border.all(color: UiPalette.slate200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: UiTypography.body.copyWith(color: UiPalette.slate500),
              ),
            ),
          ],
        );
      }

      return Column(
        children: [
          const AconsiaInfoBanner(
            icon: Icons.medical_information_outlined,
            message:
                'Bagian ini akan dilengkapi dokter setelah proses pendaftaran selesai.',
            backgroundColor: Color(0xFFFFF9E9),
            borderColor: Color(0xFFFDE7A9),
            iconColor: Color(0xFFB7800A),
            textColor: Color(0xFF8A6206),
          ),
          const Gap(UiSpacing.md),
          readOnlyField('Jenis Operasi', 'Akan diisi dokter'),
          const Gap(UiSpacing.md),
          readOnlyField('Jenis Anestesi', 'Akan diisi dokter'),
          const Gap(UiSpacing.md),
          readOnlyField('Klasifikasi ASA', 'Akan diisi dokter'),
        ],
      );
    }

    if (step == _RegisterStep.riwayat) {
      return Column(
        children: [
          CustomTextField(
            controller: noRekamMedisController,
            hintText: 'Nomor rekam medis (jika sudah ada)',
            labelText: 'Nomor Rekam Medis',
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: namaWaliController,
            hintText: 'Nama keluarga',
            labelText: 'Nama Penanggung Jawab',
            isRequired: true,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: hubunganWaliController,
            hintText: 'Suami, Istri, Anak, dll',
            labelText: 'Hubungan',
            isRequired: true,
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: nomorHpWaliController,
            hintText: '08xxxxxxxxxx',
            labelText: 'No. Telepon Penanggung Jawab',
            isRequired: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
          ),
          const Gap(UiSpacing.md),
          CustomTextField(
            controller: alamatWaliController,
            hintText: 'Alamat penanggung jawab',
            labelText: 'Alamat Penanggung Jawab',
            isRequired: true,
            maxLines: 3,
          ),
        ],
      );
    }

    return allDokter.when(
      data: (dokterList) {
        final List<Map<String, String>> items = dokterList
            .map<Map<String, String>>((d) {
          final nama = (d.namaLengkap ?? '').trim().isEmpty
              ? '-'
              : d.namaLengkap!.trim();
          final telp = (d.nomorTelepon ?? '').trim();
          final uid = (d.uid ?? '').trim();
          return <String, String>{
            'label': telp.isEmpty ? nama : '$nama ($telp)',
            'value': uid,
          };
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AconsiaInfoBanner(
              icon: Icons.person_search_outlined,
              message:
                  'Pilih dokter pendamping untuk validasi data medis dan pendampingan edukasi.',
              backgroundColor: UiPalette.blue50,
              borderColor: UiPalette.blue100,
              iconColor: UiPalette.blue600,
              textColor: UiPalette.slate700,
            ),
            const Gap(UiSpacing.md),
            if (items.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(UiSpacing.md),
                decoration: BoxDecoration(
                  color: UiPalette.slate50,
                  border: Border.all(color: UiPalette.slate200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dokter belum tersedia saat ini.',
                      style: UiTypography.body.copyWith(
                        color: UiPalette.slate700,
                      ),
                    ),
                    const Gap(UiSpacing.xs),
                    TextButton(
                      onPressed: () => ref.invalidate(
                        fetchAllDokterOptionsProvider,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
            else
              CustomDropdown(
                title: 'Dokter Pendamping',
                isRequired: true,
                itemsWithValue: items,
                selectedValue:
                    dokterController.text.isEmpty ? null : dokterController.text,
                onChanged: (value) => dokterController.text = value,
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data dokter belum berhasil dimuat. Silakan coba lagi.',
            style: UiTypography.body.copyWith(color: UiPalette.red600),
          ),
          const Gap(UiSpacing.xs),
          TextButton(
            onPressed: () => ref.invalidate(fetchAllDokterOptionsProvider),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  String _stepTitle(_RegisterStep step) {
    switch (step) {
      case _RegisterStep.akun:
        return 'Data Akun';
      case _RegisterStep.identitas:
        return 'Data Identitas Pasien';
      case _RegisterStep.medis:
        return 'Data Medis';
      case _RegisterStep.riwayat:
        return 'Riwayat & Pendamping';
      case _RegisterStep.dokter:
        return 'Dokter Pendamping';
    }
  }

  String _stepSubtitle(_RegisterStep step) {
    switch (step) {
      case _RegisterStep.akun:
        return 'Buat kredensial login pasien.';
      case _RegisterStep.identitas:
        return 'Isi identitas, sosial, dan domisili pasien.';
      case _RegisterStep.medis:
        return 'Bagian ini bersifat read-only untuk pasien.';
      case _RegisterStep.riwayat:
        return 'Lengkapi informasi penanggung jawab pasien.';
      case _RegisterStep.dokter:
        return 'Pilih dokter yang akan mendampingi pasien.';
    }
  }
}

import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/add_pasien_medic_information/post_add_pasien_medic_information_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_medic_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPasienMedicInformationPage extends HookConsumerWidget {
  final String? pasienId;
  const AddPasienMedicInformationPage({super.key, this.pasienId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namaController = useTextEditingController();
    final jenisOperasiController = useTextEditingController();
    final jenisAnestesiController = useTextEditingController();
    final klasifikasiasaController = useTextEditingController();
    final tinggiBadanController = useTextEditingController();
    final beratBadanController = useTextEditingController();

    final pasienProfileAsync =
        ref.watch(fetchPasienProfileProvider(pasienId: pasienId ?? ''));

    useEffect(() {
      final profilePasien = pasienProfileAsync.value;
      if (profilePasien != null) {
        namaController.text = profilePasien.namaLengkap ?? '';
        jenisOperasiController.text = profilePasien.jenisOperasi ?? '';
        jenisAnestesiController.text = profilePasien.jenisAnestesi ?? '';
        klasifikasiasaController.text = profilePasien.klasifikasiAsa ?? '';
        tinggiBadanController.text =
            profilePasien.tinggiBadan?.toString() ?? '';
        beratBadanController.text = profilePasien.beratBadan?.toString() ?? '';
      }
      return null;
    }, [pasienProfileAsync.value]);

    useListenable(jenisOperasiController);
    useListenable(jenisAnestesiController);
    useListenable(klasifikasiasaController);

    final postAdd = ref.watch(postAddPasienMedicInformationProvider);

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(UiSpacing.md),
          child: pasienProfileAsync.when(
            data: (_) => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AconsiaTopActionRow(
                    title: 'Review Informasi Medis',
                    subtitle: 'Lengkapi data medis inti pasien',
                    onBack: () => context.pop(),
                  ),
                  const Gap(UiSpacing.md),
                  AconsiaCardSurface(
                    radius: 14,
                    borderColor: const Color(0xFFDCEAFF),
                    padding: const EdgeInsets.all(UiSpacing.md),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: const Color(0xFFEAF2FF),
                          child: Text(
                            (namaController.text.isNotEmpty
                                    ? namaController.text
                                    : 'Pasien')
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: UiPalette.blue600,
                            ),
                          ),
                        ),
                        const Gap(UiSpacing.sm),
                        Text(
                          namaController.text.isEmpty
                              ? 'Pasien'
                              : namaController.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(UiSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F5FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Lengkapi jenis operasi, anestesi, dan klasifikasi ASA',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF23415F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(UiSpacing.md),
                  PasienMedicInformationWidget(
                    jenisOperasiController: jenisOperasiController,
                    jenisAnestesiController: jenisAnestesiController,
                    klasifikasiasaController: klasifikasiasaController,
                    tinggiBadanController: tinggiBadanController,
                    beratBadanController: beratBadanController,
                    isEditable: true,
                    isDokterInput: true,
                  ),
                ],
              ),
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.only(top: UiSpacing.xxxl),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.only(top: UiSpacing.xxxl),
                child: Text('Gagal memuat data pasien: $error'),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Button.filled(
          disabled: jenisOperasiController.text.isEmpty ||
              jenisAnestesiController.text.isEmpty ||
              klasifikasiasaController.text.isEmpty ||
              postAdd.isLoading,
          onPressed: () => ref
              .read(postAddPasienMedicInformationProvider.notifier)
              .postAddPasienMedicInformation(
                pasienId: pasienId!,
                profile: PasienProfileModel(
                  jenisOperasi: jenisOperasiController.text,
                  jenisAnestesi: jenisAnestesiController.text,
                  klasifikasiAsa: klasifikasiasaController.text,
                ),
                onSuccess: (message) {
                  context.showSuccessDialog(context, message);
                  context.goNamed(RouteName.mainDokter);
                },
                onError: (message) {
                  context.showErrorSnackbar(context, message);
                },
              ),
          label: postAdd.isLoading ? 'Menyimpan...' : 'Simpan Informasi Medis',
          height: 52,
          borderRadius: 12,
        ),
      ),
    );
  }
}

import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/add_pasien_medic_information/post_add_pasien_medic_information_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_medic_information_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:flutter/material.dart';
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

    final profilePasien =
        ref.watch(fetchPasienProfileProvider(pasienId: pasienId ?? '')).value;

    useEffect(() {
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
    }, [profilePasien]);

    useListenable(jenisOperasiController);
    useListenable(jenisAnestesiController);
    useListenable(klasifikasiasaController);

    final postAdd = ref.watch(postAddPasienMedicInformationProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tambah Informasi Medis Pasien',
        centertitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                namaController.text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Pasien',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.primaryWhite,
                  ),
                ),
              ),
              Gap(16),
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
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
        ),
      ),
    );
  }
}

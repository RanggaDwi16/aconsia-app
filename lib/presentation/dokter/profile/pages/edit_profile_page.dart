import 'dart:io';

import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/services/image_picker_service.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_count_by_dokter_id/fetch_pasien_count_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/reading_session_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_count_by_dokter_id/fetch_konten_count_by_dokter_id_provider.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/get_dokter_profile/fetch_dokter_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/update_dokter_profile/patch_dokter_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/providers/upload_photo_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/profile/widgets/doctor_contact_widget.dart';
import 'package:aconsia_app/presentation/dokter/profile/widgets/doctor_personal_information_widget.dart';
import 'package:aconsia_app/presentation/dokter/profile/widgets/doctor_profesional_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditProfilePage extends StatefulHookConsumerWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final imagePickerService = ImagePickerService();
  File? selectedImage;

  // Pick image saja, tidak upload langsung
  Future<void> _pickImage() async {
    final result = await imagePickerService.pickImageFromGallery();
    result.fold(
      (failure) {
        context.showErrorSnackbar(context, failure.message);
      },
      (file) {
        setState(() {
          selectedImage = file;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final spesialisasiController =
        useTextEditingController(text: 'Dokter Spesialis Anestesiologi');
    final nomorstrController = useTextEditingController();
    final nomorsipController = useTextEditingController();
    final hospitalNameController = useTextEditingController();
    final tanggalGabungController = useTextEditingController();
    final namaController = useTextEditingController();
    final emailController = useTextEditingController();
    final nomorHpController = useTextEditingController();

    final updateProfile = ref.watch(patchDokterProfileProvider);
    final uploadPhotoState = ref.watch(uploadPhotoControllerProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final profileDokter = ref.watch(fetchDokterProfileProvider(uid: uid ?? ''));

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

      profileDokter.whenData((dokterProfile) {
        if (dokterProfile != null) {
          nomorstrController.text = dokterProfile.nomorStr ?? '';
          nomorsipController.text = dokterProfile.nomorSip ?? '';
          hospitalNameController.text = dokterProfile.hospitalName ?? '';
          tanggalGabungController.text = dokterProfile.tanggalGabung ?? '';
          namaController.text = dokterProfile.namaLengkap ?? '';
          nomorHpController.text = dokterProfile.nomorTelepon ?? '';
        } else {}
      });

      return null;
    }, [profileDokter]);

    useListenable(spesialisasiController);
    useListenable(nomorstrController);
    useListenable(nomorsipController);
    useListenable(hospitalNameController);
    useListenable(tanggalGabungController);
    useListenable(namaController);
    useListenable(emailController);
    useListenable(nomorHpController);

    final allFieldsEmpty = nomorstrController.text.isEmpty ||
        nomorsipController.text.isEmpty ||
        hospitalNameController.text.isEmpty ||
        namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        nomorHpController.text.isEmpty;

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(UiSpacing.md),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AconsiaTopActionRow(
                  title: 'Edit Profil',
                  subtitle: 'Perbarui data personal dan profesional dokter',
                  onBack: () => Navigator.of(context).pop(),
                ),
                const Gap(UiSpacing.md),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Photo with loading overlay
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : (profileDokter.value?.fotoProfilUrl != null &&
                                      profileDokter
                                          .value!.fotoProfilUrl!.isNotEmpty)
                                  ? NetworkImage(
                                      profileDokter.value!.fotoProfilUrl!)
                                  : AssetImage(
                                          Assets.images.placeholderImg.path)
                                      as ImageProvider,
                        ),
                        // Loading overlay
                        if (uploadPhotoState.isUploading)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Edit button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: uploadPhotoState.isUploading ? null : _pickImage,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: uploadPhotoState.isUploading
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            uploadPhotoState.isUploading
                                ? Icons.hourglass_empty
                                : Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(UiSpacing.sm),
                Text(
                  namaController.text.isNotEmpty
                      ? namaController.text
                      : 'Nama Dokter',
                  style: UiTypography.title.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(UiSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiSpacing.sm,
                    vertical: UiSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: UiPalette.emerald600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Aktif',
                    style: UiTypography.caption.copyWith(
                      color: UiPalette.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(UiSpacing.xl),
                DoctorProfesionalInformationWidget(
                  isEditable: true,
                  spesialisasiController: spesialisasiController,
                  nomorstrController: nomorstrController,
                  nomorsipController: nomorsipController,
                  hospitalNameController: hospitalNameController,
                  tanggalGabungController: tanggalGabungController,
                ),
                const Gap(UiSpacing.md),
                DoctorPersonalInformationWidget(
                  isEditable: true,
                  namaController: namaController,
                ),
                const Gap(UiSpacing.md),
                DoctorContactWidget(
                  isEditable: true,
                  emailController: emailController,
                  nomorHpController: nomorHpController,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Button.filled(
          disabled: updateProfile.isLoading ||
              uploadPhotoState.isUploading ||
              allFieldsEmpty,
          onPressed: () async {
            // 1. Upload foto dulu jika ada selectedImage
            String? photoUrl;
            if (selectedImage != null) {
              await ref
                  .read(uploadPhotoControllerProvider.notifier)
                  .uploadDokterPhoto(
                    uid: uid!,
                    imageFile: selectedImage!,
                    onSuccess: (url) {
                      photoUrl = url;
                    },
                    onError: (error) {
                      context.showErrorSnackbar(context, error);
                    },
                  );
            }

            // 2. Update profile dengan foto URL (jika berhasil upload) atau pakai yang lama
            final finalPhotoUrl =
                photoUrl ?? profileDokter.value?.fotoProfilUrl;

            ref.read(patchDokterProfileProvider.notifier).updateProfile(
                  model: DokterProfileModel(
                    uid: uid ?? '',
                    namaLengkap: namaController.text,
                    email: emailController.text,
                    nomorTelepon: nomorHpController.text,
                    spesialisasi: spesialisasiController.text,
                    nomorStr: nomorstrController.text,
                    nomorSip: nomorsipController.text,
                    hospitalName: hospitalNameController.text,
                    status: profileDokter.value?.status ?? 'active',
                    tanggalGabung: tanggalGabungController.text,
                    fotoProfilUrl: finalPhotoUrl,
                  ),
                  onSuccess: (message) {
                    ref
                        .read(authenticationProvider.notifier)
                        .updateProfileCompleted(
                          uid: uid!,
                          isCompleted: true,
                          onSuccess: (message) {
                            context.showSuccessEditDialog();
                            ref.invalidate(
                                fetchDokterProfileProvider(uid: uid));
                            ref.invalidate(fetchDokterProfileProvider);
                            ref.invalidate(fetchKontenByDokterIdProvider);
                            ref.invalidate(fetchKontenCountByDokterIdProvider);
                            ref.invalidate(fetchPasienCountByDokterIdProvider);
                            ref.invalidate(activeReadingSessionsStreamProvider);
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
          label: uploadPhotoState.isUploading
              ? 'Mengupload Foto...'
              : updateProfile.isLoading
                  ? 'Menyimpan...'
                  : 'Simpan Perubahan',
        ),
      ),
    );
  }
}

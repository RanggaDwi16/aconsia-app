import 'dart:io';

import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/services/image_picker_service.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_count_by_dokter_id/fetch_pasien_count_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/reading_session_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_count_by_dokter_id/fetch_konten_count_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/get_dokter_profile/fetch_dokter_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/update_dokter_profile/patch_dokter_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/providers/upload_photo_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
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
    final tanggalGabungController = useTextEditingController();
    final namaController = useTextEditingController();
    final tempatLahirController = useTextEditingController();
    final tanggalLahirController = useTextEditingController();
    final jenisKelaminController = useTextEditingController();
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
          tanggalGabungController.text = dokterProfile.tanggalGabung ?? '';
          namaController.text = dokterProfile.namaLengkap ?? '';
          tempatLahirController.text = dokterProfile.tempatLahir ?? '';
          tanggalLahirController.text = dokterProfile.tanggalLahir ?? '';
          jenisKelaminController.text = dokterProfile.jenisKelamin ?? '';
          nomorHpController.text = dokterProfile.nomorTelepon ?? '';
        } else {}
      });

      return null;
    }, [profileDokter]);

    useListenable(spesialisasiController);
    useListenable(nomorstrController);
    useListenable(nomorsipController);
    useListenable(tanggalGabungController);
    useListenable(namaController);
    useListenable(tempatLahirController);
    useListenable(tanggalLahirController);
    useListenable(jenisKelaminController);
    useListenable(emailController);
    useListenable(nomorHpController);

    final allFieldsEmpty = nomorstrController.text.isEmpty ||
        nomorsipController.text.isEmpty ||
        tanggalGabungController.text.isEmpty ||
        namaController.text.isEmpty ||
        tempatLahirController.text.isEmpty ||
        tanggalLahirController.text.isEmpty ||
        jenisKelaminController.text.isEmpty ||
        emailController.text.isEmpty ||
        nomorHpController.text.isEmpty;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        centertitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                                : AssetImage(Assets.images.placeholderImg.path)
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
              const Gap(8),
              Text(
                namaController.text.isNotEmpty
                    ? namaController.text
                    : 'Nama Dokter',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.backgroundStatusAktifColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.primaryWhite,
                  ),
                ),
              ),
              const Gap(24),
              DoctorProfesionalInformationWidget(
                isEditable: true,
                spesialisasiController: spesialisasiController,
                nomorstrController: nomorstrController,
                nomorsipController: nomorsipController,
                tanggalGabungController: tanggalGabungController,
              ),
              const Gap(16),
              DoctorPersonalInformationWidget(
                isEditable: true,
                namaController: namaController,
                tempatLahirController: tempatLahirController,
                tanggalLahirController: tanggalLahirController,
                jenisKelaminController: jenisKelaminController,
              ),
              const Gap(16),
              DoctorContactWidget(
                isEditable: true,
                emailController: emailController,
                nomorHpController: nomorHpController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    tempatLahir: tempatLahirController.text,
                    tanggalLahir: tanggalLahirController.text,
                    jenisKelamin: jenisKelaminController.text,
                    email: emailController.text,
                    nomorTelepon: nomorHpController.text,
                    spesialisasi: spesialisasiController.text,
                    nomorStr: nomorstrController.text,
                    nomorSip: nomorsipController.text,
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

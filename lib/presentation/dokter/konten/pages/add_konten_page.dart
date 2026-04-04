import 'dart:io';

import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_dropdown.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/services/image_picker_service.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/create_konten/post_create_konten_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/providers/upload_photo_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/data/data_konten.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddKontenPage extends HookConsumerWidget {
  const AddKontenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final judulController = useTextEditingController();
    final jenisAnestesiController = useTextEditingController();
    final indikasiTindakanController = useTextEditingController();
    final tataCaraController = useTextEditingController();
    final resikoTindakanController = useTextEditingController();
    final komplikasiController = useTextEditingController();
    final prognosisController = useTextEditingController();
    final alternatifLainController = useTextEditingController();
    final judulBagianController = useTextEditingController();
    final isiKontenController = useTextEditingController();

    // State untuk selected image
    final selectedImage = useState<File?>(null);

    final createKonten = ref.watch(postCreateKontenProvider);
    final uploadPhotoState = ref.watch(uploadPhotoControllerProvider);

    final uid = FirebaseAuth.instance.currentUser?.uid;

    // Method untuk pick image (tidak langsung upload)
    Future<void> pickImage() async {
      final result = await ImagePickerService().pickImageFromGallery();

      result.fold(
        (failure) => context.showErrorSnackbar(context, failure.message),
        (file) => selectedImage.value = file,
      );
    }

    useListenable(judulController);
    useListenable(jenisAnestesiController);
    useListenable(tataCaraController);
    useListenable(resikoTindakanController);
    useListenable(komplikasiController);
    useListenable(indikasiTindakanController);
    useListenable(prognosisController);
    useListenable(alternatifLainController);
    useListenable(judulBagianController);
    useListenable(isiKontenController);

    final isEmpty = judulController.text.isEmpty ||
        jenisAnestesiController.text.isEmpty ||
        tataCaraController.text.isEmpty ||
        resikoTindakanController.text.isEmpty ||
        komplikasiController.text.isEmpty ||
        indikasiTindakanController.text.isEmpty ||
        prognosisController.text.isEmpty ||
        alternatifLainController.text.isEmpty ||
        judulBagianController.text.isEmpty ||
        isiKontenController.text.isEmpty;

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(UiSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AconsiaTopActionRow(
                title: 'Buat Konten Baru',
                subtitle: 'Tambah materi edukasi untuk pasien',
                onBack: () => context.pop(),
              ),
              const Gap(UiSpacing.md),
              const AconsiaSectionTitle(
                title: 'Informasi Dasar',
                subtitle: 'Detail umum tentang konten edukasi',
                titleSize: 22,
              ),
              const Gap(UiSpacing.md),
            CustomTextField(
              isRequired: true,
              controller: judulController,
              labelText: 'Judul Konten',
              hintText: 'Masukkan judul konten',
            ),
            const Gap(UiSpacing.md),
            CustomDropdown(
              isRequired: true,
              items: jenisAnestesi,
              title: 'Jenis Anestesi',
              onChanged: (p0) {
                jenisAnestesiController.text = p0;
              },
              selectedValue: jenisAnestesiController.text.isEmpty
                  ? null
                  : jenisAnestesiController.text,
            ),
            const Gap(UiSpacing.md),
            CustomDropdown(
              isRequired: true,
              items: tataCara,
              title: 'Tata Cara',
              onChanged: (p0) {
                tataCaraController.text = p0;
              },
              selectedValue: tataCaraController.text.isEmpty
                  ? null
                  : tataCaraController.text,
            ),
            const Gap(UiSpacing.md),
            CustomDropdown(
              isRequired: true,
              items: resikoTindakan,
              title: 'Resiko Tindakan',
              onChanged: (p0) {
                resikoTindakanController.text = p0;
              },
              selectedValue: resikoTindakanController.text.isEmpty
                  ? null
                  : resikoTindakanController.text,
            ),
            const Gap(UiSpacing.md),
            CustomDropdown(
              isRequired: true,
              items: komplikasi,
              title: 'Komplikasi',
              onChanged: (p0) {
                komplikasiController.text = p0;
              },
              selectedValue: komplikasiController.text.isEmpty
                  ? null
                  : komplikasiController.text,
            ),
            const Gap(UiSpacing.md),
            CustomDropdown(
              isRequired: true,
              items: indikasiTindakan,
              title: 'Indikasi Tindakan',
              onChanged: (p0) {
                indikasiTindakanController.text = p0;
              },
              selectedValue: indikasiTindakanController.text.isEmpty
                  ? null
                  : indikasiTindakanController.text,
            ),
            const Gap(UiSpacing.md),
            CustomTextField(
              controller: prognosisController,
              labelText: 'Prognosis',
              hintText: 'Masukkan prognosis',
              isRequired: true,
            ),
            const Gap(UiSpacing.md),
            CustomTextField(
              controller: alternatifLainController,
              labelText: 'Alternatif Lain dan resiko',
              hintText: 'Masukkan alternatif lain dan resiko',
              isRequired: true,
            ),
            const Gap(UiSpacing.xxl),
            const AconsiaSectionTitle(
              title: 'Gambar Konten',
              subtitle: 'Berikan gambaran tentang konten edukasi Anda',
              titleSize: 22,
            ),
            const Gap(UiSpacing.md),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                padding: const EdgeInsets.all(UiSpacing.md),
                height: context.deviceHeight * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: UiPalette.slate200,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage.value != null
                    ? Stack(
                        children: [
                          // Preview gambar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImage.value!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Overlay dengan tombol ganti
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                  Gap(8),
                                  Text(
                                    'Tap untuk ganti gambar',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.icons.icUpload.path,
                              width: 48,
                              height: 48,
                              colorFilter: const ColorFilter.mode(
                                UiPalette.slate500,
                                BlendMode.srcIn,
                              ),
                            ),
                            const Gap(UiSpacing.sm),
                            Text(
                              'Upload Gambar Konten',
                              style: TextStyle(
                                fontSize: 16,
                                color: UiPalette.slate500,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const Gap(UiSpacing.xxl),
            const AconsiaSectionTitle(
              title: 'Bagian Konten',
              subtitle: 'Materi edukasi yang akan dipelajari pasien',
              titleSize: 22,
            ),
            const Gap(UiSpacing.md),
            Container(
              padding: const EdgeInsets.all(UiSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(
                  color: UiPalette.slate200,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bagian',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.slate900,
                    ),
                  ),
                  const Gap(UiSpacing.md),
                  CustomTextField(
                    isRequired: true,
                    controller: judulBagianController,
                    labelText: 'Judul Bagian',
                    hintText: 'Masukkan judul bagian konten',
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
          ],
        ),
      ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Button.filled(
          disabled:
              isEmpty || createKonten.isLoading || uploadPhotoState.isUploading,
          onPressed: () async {
            // 1. Upload gambar dulu jika ada
            String? imageUrl;
            if (selectedImage.value != null) {
              await ref
                  .read(uploadPhotoControllerProvider.notifier)
                  .uploadKontenImage(
                    imageFile: selectedImage.value!,
                    fileName: 'konten_${DateTime.now().millisecondsSinceEpoch}',
                    onSuccess: (url) {
                      imageUrl = url;
                    },
                    onError: (error) {
                      context.showErrorSnackbar(context, error);
                    },
                  );

              // Jika upload gagal, stop
              if (imageUrl == null) return;
            }

            // 2. Create konten dengan gambarUrl (jika ada)
            ref.read(postCreateKontenProvider.notifier).postCreateKonten(
                  konten: KontenModel(
                    dokterId: uid ?? '',
                    judul: judulController.text,
                    jenisAnestesi: jenisAnestesiController.text,
                    tataCara: tataCaraController.text,
                    resikoTindakan: resikoTindakanController.text,
                    komplikasi: komplikasiController.text,
                    indikasiTindakan: indikasiTindakanController.text,
                    prognosis: prognosisController.text,
                    alternatifLain: alternatifLainController.text,
                    gambarUrl: imageUrl, // Tambahkan URL gambar
                    jumlahBagian: 1,
                    status: 'published',
                    createdAt: DateTime.now(),
                  ),
                  sections: [
                    KontenSectionModel(
                      kontenId: '',
                      judulBagian: judulBagianController.text,
                      isiKonten: isiKontenController.text,
                      urutan: 1,
                    ),
                  ],
                  onSuccess: (message) {
                    context.showSuccessDialog(
                        context, 'Konten berhasil dibuat.');
                    ref.invalidate(
                        fetchKontenByDokterIdProvider(dokterId: uid ?? ''));
                    context.pop();
                  },
                  onError: (messagge) {
                    context.showErrorSnackbar(context, messagge);
                  },
                );
          },
          label: uploadPhotoState.isUploading
              ? 'Mengupload Gambar...'
              : createKonten.isLoading
                  ? 'Membuat Konten...'
                  : 'Upload Konten',
          icon: SvgPicture.asset(
            Assets.icons.icSave.path,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

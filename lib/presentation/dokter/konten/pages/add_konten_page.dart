import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_dropdown.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/create_konten/post_create_konten_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/data/data_konten.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddKontenPage extends HookConsumerWidget {
  const AddKontenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final judulController = useTextEditingController();
    final jenisAnestesiController = useTextEditingController();
    final isiKontenController = useTextEditingController();
    final deskripsiSingkatController = useTextEditingController();

    final createKonten = ref.watch(postCreateKontenProvider);

    final uid = FirebaseAuth.instance.currentUser?.uid;

    useListenable(judulController);
    useListenable(jenisAnestesiController);
    useListenable(isiKontenController);
    useListenable(deskripsiSingkatController);

    final isEmpty = judulController.text.trim().isEmpty ||
        jenisAnestesiController.text.trim().isEmpty ||
        deskripsiSingkatController.text.trim().isEmpty ||
        isiKontenController.text.trim().isEmpty;

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(UiSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AconsiaTopActionRow(
                title: 'Tambah Konten Edukasi Baru',
                subtitle:
                    'Konten baru akan disimpan sebagai draft dan dapat diperbarui kapan saja.',
                onBack: () => context.pop(),
              ),
              const Gap(UiSpacing.md),
            CustomTextField(
              isRequired: true,
              controller: judulController,
              labelText: 'Judul',
              hintText: 'Contoh: Persiapan Anestesi Spinal untuk Pasien',
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
            CustomTextField(
              isRequired: true,
              controller: deskripsiSingkatController,
              labelText: 'Deskripsi Singkat',
              hintText: 'Masukkan deskripsi singkat konten',
              maxLines: 3,
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Button.outlined(
                onPressed: () => context.pop(),
                label: 'Batal',
                disabled: createKonten.isLoading,
                borderColor: UiPalette.slate300,
                textColor: UiPalette.slate700,
              ),
            ),
            const Gap(UiSpacing.sm),
            Expanded(
              child: Button.filled(
                disabled: isEmpty || createKonten.isLoading,
                onPressed: () async {
                  ref.read(postCreateKontenProvider.notifier).postCreateKonten(
                        konten: KontenModel(
                          dokterId: uid ?? '',
                          judul: judulController.text.trim(),
                          jenisAnestesi: jenisAnestesiController.text.trim(),
                          indikasiTindakan: deskripsiSingkatController.text.trim(),
                          jumlahBagian: 1,
                          status: 'draft',
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                        sections: [
                          KontenSectionModel(
                            kontenId: '',
                            judulBagian: 'Bagian 1',
                            isiKonten: isiKontenController.text.trim(),
                            urutan: 1,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        ],
                        onSuccess: (message) {
                          context.showSuccessDialog(
                            context,
                            'Konten berhasil disimpan sebagai draft.',
                          );
                          ref.invalidate(
                            fetchKontenByDokterIdProvider(dokterId: uid ?? ''),
                          );
                          context.pop();
                        },
                        onError: (messagge) {
                          final messageLower = messagge.toLowerCase();
                          final friendly = messageLower.contains('permission-denied')
                              ? 'Akses dokter belum sinkron. Silakan login ulang lalu coba lagi, atau hubungi admin.'
                              : messagge;
                          context.showErrorSnackbar(context, friendly);
                        },
                      );
                },
                label: createKonten.isLoading
                    ? 'Menyimpan Draft...'
                    : 'Simpan Draft',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

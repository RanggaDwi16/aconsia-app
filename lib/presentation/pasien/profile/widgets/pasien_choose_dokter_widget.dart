import 'package:aconsia_app/core/helpers/widgets/custom_dropdown.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_all_dokter_options/fetch_all_dokter_options_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasienChooseDokterWidget extends HookConsumerWidget {
  final bool? isEditable;
  final TextEditingController dokterController;

  const PasienChooseDokterWidget({
    super.key,
    required this.dokterController,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDokter = ref.watch(fetchAllDokterOptionsProvider);
    final editable = isEditable ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.md,
        vertical: UiSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: UiPalette.white,
        border: Border.all(color: UiPalette.slate200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            iconPath: Assets.icons.icPerson.path,
            title: 'Informasi Dokter Pilihan',
            subtitle: 'Data dokter pendamping pasien',
          ),
          const Gap(UiSpacing.lg),
          allDokter.when(
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

              if (items.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dokter belum tersedia.',
                      style: TextStyle(color: UiPalette.slate500),
                    ),
                    const Gap(UiSpacing.xs),
                    TextButton(
                      onPressed: () => ref.invalidate(fetchAllDokterOptionsProvider),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                );
              }

              return CustomDropdown(
                title: 'Pilih Dokter',
                itemsWithValue: items,
                selectedValue: dokterController.text.isEmpty
                    ? null
                    : dokterController.text,
                onChanged: (selectedId) {
                  dokterController.text = selectedId;
                },
                disabled: !editable,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gagal memuat data dokter. Silakan coba lagi.',
                  style: TextStyle(color: UiPalette.red600),
                ),
                const Gap(UiSpacing.xs),
                TextButton(
                  onPressed: () => ref.invalidate(fetchAllDokterOptionsProvider),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.iconPath,
    required this.title,
    required this.subtitle,
  });

  final String iconPath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: UiPalette.blue50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter:
                  const ColorFilter.mode(UiPalette.blue600, BlendMode.srcIn),
            ),
          ),
        ),
        const Gap(UiSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: UiPalette.slate900,
                ),
              ),
              const Gap(UiSpacing.xxs),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: UiPalette.slate500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

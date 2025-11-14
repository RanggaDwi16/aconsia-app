import 'package:aconsia_app/presentation/pasien/profile/controllers/get_all_dokter_options/fetch_all_dokter_options_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_dropdown.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

    print('dokterController value: ${dokterController.text}');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Row(
            children: [
              SvgPicture.asset(
                Assets.icons.icPerson.path,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColor.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              const Gap(12),
              const Text(
                'Informasi Dokter Pilihan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                Assets.icons.icEdit.path,
                width: 20,
                height: 20,
              ),
            ],
          ),

          const Gap(4),
          const Text(
            'Data dokter pilihan pasien',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.textGrayColor,
            ),
          ),

          const Gap(24),

          // 🔹 Dropdown dengan state provider
          allDokter.when(
            data: (dokterList) {
              // kalau data null atau kosong, tampilkan dropdown kosong
              print('Fetched dokter list: $dokterList');
              final items = dokterList!.map((d) {
                return {
                  'label': "${d.namaLengkap ?? '-'} (${d.nomorTelepon ?? ''})",
                  'value': d.uid ?? '',
                };
              }).toList();

              return CustomDropdown(
                title: 'Pilih Dokter',
                itemsWithValue: items, // 🔹 gunakan itemsWithValue
                selectedValue: dokterController.text.isEmpty
                    ? null
                    : dokterController.text,
                onChanged: (selectedId) {
                  dokterController.text =
                      selectedId; // 🔹 simpan dokterId ke controller
                },
                disabled: !(isEditable ?? false),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Text(
              "Gagal memuat data dokter: $error",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

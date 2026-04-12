import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_comprehension_score_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_learning_summary_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gap/gap.dart';

class PasienSidebarDrawer extends ConsumerWidget {
  final int selectedIndex;

  const PasienSidebarDrawer({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final profile = ref.watch(fetchPasienProfileProvider(pasienId: uid)).value;
    final dokterId = profile?.dokterId ?? '';

    final comprehensionScore = uid.isNotEmpty
        ? ref.watch(pasienComprehensionScoreProvider(uid)).valueOrNull?.score ?? 0
        : 0;
    final progressMateri = uid.isNotEmpty && dokterId.isNotEmpty
        ? ref
                .watch(
                  pasienLearningSummaryProvider(
                    PasienLearningSummaryParams(
                      pasienId: uid,
                      dokterId: dokterId,
                    ),
                  ),
                )
                .valueOrNull
                ?.completionRate ??
            0
        : 0;

    final items = const <_DrawerItem>[
      _DrawerItem(
        index: 0,
        label: 'Dashboard',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
      ),
      _DrawerItem(
        index: 1,
        label: 'Profil Saya',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
      ),
      _DrawerItem(
        index: 2,
        label: 'Asesmen Pra-Operasi',
        icon: Icons.assignment_outlined,
        activeIcon: Icons.assignment_rounded,
      ),
      _DrawerItem(
        index: 3,
        label: 'Materi Edukasi',
        icon: Icons.menu_book_outlined,
        activeIcon: Icons.menu_book_rounded,
      ),
      _DrawerItem(
        index: 4,
        label: 'Chat AI Assistant',
        icon: Icons.smart_toy_outlined,
        activeIcon: Icons.smart_toy_rounded,
      ),
      _DrawerItem(
        index: 5,
        label: 'Hubungi Dokter',
        icon: Icons.call_outlined,
        activeIcon: Icons.call_rounded,
      ),
      _DrawerItem(
        index: 6,
        label: 'Jadwal Tanda Tangan',
        icon: Icons.calendar_month_outlined,
        activeIcon: Icons.calendar_month_rounded,
      ),
    ];

    final displayName = (profile?.namaLengkap ?? '').trim().isEmpty
        ? 'Pasien'
        : profile!.namaLengkap!.trim();
    final displayMrn = (profile?.noRekamMedis ?? '').trim().isEmpty
        ? '-'
        : profile!.noRekamMedis!.trim();
    final displayAnestesi = (profile?.jenisAnestesi ?? '').trim().isEmpty
        ? '-'
        : profile!.jenisAnestesi!.trim();

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.84,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1D4ED8),
                    Color(0xFF06B6D4),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  UiSpacing.md,
                  UiSpacing.md,
                  UiSpacing.md,
                  UiSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                    const Gap(UiSpacing.xs),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6F0FF),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        displayName.substring(0, 1).toUpperCase(),
                        style: UiTypography.h2.copyWith(
                          color: UiPalette.blue600,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Gap(UiSpacing.sm),
                    Text(
                      displayName,
                      style: UiTypography.h2.copyWith(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      'MRN: $displayMrn',
                      style: UiTypography.bodySmall.copyWith(
                        color: const Color(0xFFE6F0FF),
                      ),
                    ),
                    const Gap(UiSpacing.xs),
                    Wrap(
                      spacing: UiSpacing.xs,
                      runSpacing: UiSpacing.xs,
                      children: [
                        _HeaderChip(
                          label: 'Pemahaman AI: $comprehensionScore%',
                        ),
                        _HeaderChip(
                          label: 'Progress Materi: ${progressMateri.toStringAsFixed(0)}%',
                        ),
                        _HeaderChip(label: displayAnestesi),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  UiSpacing.sm,
                  UiSpacing.sm,
                  UiSpacing.sm,
                  UiSpacing.sm,
                ),
                children: items.map((item) {
                  final active = selectedIndex == item.index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        ref.read(selectedIndexPasienProvider.notifier).state =
                            item.index;
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: UiSpacing.sm,
                          vertical: UiSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFEFF6FF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              active ? item.activeIcon : item.icon,
                              color: active
                                  ? UiPalette.blue600
                                  : UiPalette.slate600,
                            ),
                            const Gap(UiSpacing.sm),
                            Expanded(
                              child: Text(
                                item.label,
                                style: UiTypography.body.copyWith(
                                  color: active
                                      ? UiPalette.blue600
                                      : UiPalette.slate800,
                                  fontWeight: active
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                UiSpacing.md,
                UiSpacing.sm,
                UiSpacing.md,
                UiSpacing.md,
              ),
              child: OutlinedButton.icon(
                onPressed: () {
                  context.showLogoutDialog();
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: UiPalette.red600,
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final String label;

  const _HeaderChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x66EFF6FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x66BFDBFE)),
      ),
      child: Text(
        label,
        style: UiTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DrawerItem {
  final int index;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _DrawerItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

import 'package:aconsia_app/assignment/controllers/create_assignment/post_create_assignment_provider.dart';
import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:aconsia_app/core/helpers/formatters/date_formatter.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/delete_konten/put_konten_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_list_by_dokter_id/fetch_pasien_list_by_dokter_id_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _activeAssignmentCountByKontenProvider =
    FutureProvider.autoDispose.family<int, String>((ref, key) async {
  final parts = key.split('::');
  if (parts.length != 2) return 0;
  final dokterId = parts[0].trim();
  final kontenId = parts[1].trim();
  if (dokterId.isEmpty || kontenId.isEmpty) return 0;

  final repository = ref.read(assignmentRepositoryProvider);
  final result = await repository.getAssignmentsByDokterAndKonten(
    dokterId: dokterId,
    kontenId: kontenId,
  );

  return result.fold((_) => 0, (assignments) => assignments.length);
});

class ItemKontenWidget extends ConsumerWidget {
  final KontenModel konten;
  final bool? isHome;

  const ItemKontenWidget({
    super.key,
    required this.konten,
    this.isHome = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dokterUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final kontenId = (konten.id ?? '').trim();
    final assignmentKey = dokterUid.isNotEmpty && kontenId.isNotEmpty
        ? '$dokterUid::$kontenId'
        : '';
    final assignmentCountAsync = assignmentKey.isEmpty
        ? const AsyncData<int>(0)
        : ref.watch(_activeAssignmentCountByKontenProvider(assignmentKey));

    final anesthesia = (konten.jenisAnestesi ?? '-').trim();
    final status = (konten.status ?? 'draft').trim().toLowerCase();
    final statusLabel = status == 'published' ? 'Published' : 'Draft';
    final description =
        (konten.indikasiTindakan ?? 'Deskripsi belum tersedia').trim();
    final createdAt = konten.createdAt ?? konten.updatedAt;
    final createdLabel = DateFormatter.formatDate(createdAt);

    return AconsiaCardSurface(
      radius: 12,
      borderColor: const Color(0xFFE2E8F0),
      padding: const EdgeInsets.symmetric(
        horizontal: UiSpacing.md,
        vertical: UiSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.description_outlined,
                size: 20,
                color: UiPalette.blue600,
              ),
              const Gap(UiSpacing.xs),
              Expanded(
                child: Text(
                  konten.judul ?? 'Tanpa Judul',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: UiPalette.slate900,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          Wrap(
            spacing: UiSpacing.xs,
            runSpacing: UiSpacing.xs,
            children: [
              _buildTag(
                text: anesthesia,
                bgColor: UiPalette.blue50,
                textColor: UiPalette.blue600,
              ),
              _buildTag(
                text: statusLabel,
                bgColor: status == 'published'
                    ? const Color(0xFFF0FDF4)
                    : const Color(0xFFFFFBEB),
                textColor: status == 'published'
                    ? const Color(0xFF166534)
                    : const Color(0xFF92400E),
                borderColor: status == 'published'
                    ? const Color(0xFFBBF7D0)
                    : const Color(0xFFFDE68A),
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: UiPalette.slate600,
              height: 1.35,
            ),
          ),
          const Gap(UiSpacing.xs),
          Text(
            'Dibuat: $createdLabel',
            style: const TextStyle(
              fontSize: 12.5,
              color: UiPalette.slate500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(UiSpacing.xxs),
          assignmentCountAsync.when(
            data: (count) => Text(
              'Assigned aktif: $count pasien',
              style: const TextStyle(
                fontSize: 12,
                color: UiPalette.slate600,
                fontWeight: FontWeight.w600,
              ),
            ),
            loading: () => const Text(
              'Assigned aktif: ...',
              style: TextStyle(
                fontSize: 12,
                color: UiPalette.slate500,
                fontWeight: FontWeight.w500,
              ),
            ),
            error: (_, __) => const Text(
              'Assigned aktif: -',
              style: TextStyle(
                fontSize: 12,
                color: UiPalette.slate500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (status != 'published') ...[
            const Gap(UiSpacing.xxs),
            const Text(
              'Konten draft belum bisa di-assign. Publish via Admin terlebih dahulu.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF92400E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (isHome == false) ...[
            const Gap(UiSpacing.sm),
            _buildActionButtons(
              context,
              ref,
              canAssign: status == 'published',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref, {
    required bool canAssign,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVeryNarrow = constraints.maxWidth < 320;
        if (isVeryNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAssignButton(
                context,
                ref,
                fullWidth: true,
                canAssign: canAssign,
              ),
              const Gap(UiSpacing.xs),
              _buildManageAssignmentButton(context, ref, fullWidth: true),
              const Gap(UiSpacing.xs),
              _buildEditButton(context, fullWidth: true),
              const Gap(UiSpacing.xs),
              _buildDeleteButton(context, ref, fullWidth: true),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildAssignButton(context, ref, canAssign: canAssign),
            const Gap(UiSpacing.xs),
            _buildManageAssignmentButton(context, ref),
            const Gap(UiSpacing.xs),
            _buildEditButton(context),
            const Gap(UiSpacing.xs),
            _buildDeleteButton(context, ref),
          ],
        );
      },
    );
  }

  Widget _buildTag({
    required String text,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context, {bool fullWidth = false}) {
    return OutlinedButton.icon(
      onPressed: () =>
          context.pushNamed(RouteName.editKonten, extra: konten.id),
      icon: const Icon(Icons.edit_outlined, size: 14),
      label: const Text(
        'Edit',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: UiPalette.slate700,
        side: const BorderSide(color: Color(0xFFD1D5DB)),
        minimumSize: Size(fullWidth ? double.infinity : 0, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildAssignButton(
    BuildContext context,
    WidgetRef ref, {
    bool fullWidth = false,
    bool canAssign = true,
  }) {
    return OutlinedButton.icon(
      onPressed: canAssign ? () => _showAssignDialog(context, ref) : null,
      icon: const Icon(Icons.person_add_alt_1_rounded, size: 14),
      label: const Text(
        'Assign',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: canAssign ? UiPalette.blue600 : UiPalette.slate400,
        side: BorderSide(
          color: canAssign ? UiPalette.blue100 : UiPalette.slate300,
        ),
        minimumSize: Size(fullWidth ? double.infinity : 0, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _showAssignDialog(BuildContext context, WidgetRef ref) async {
    final dokterUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final kontenId = (konten.id ?? '').trim();
    final kontenStatus = (konten.status ?? '').trim().toLowerCase();
    if (dokterUid.isEmpty) {
      context.showErrorSnackbar(context, 'Sesi dokter tidak ditemukan.');
      return;
    }
    if (kontenId.isEmpty) {
      context.showErrorSnackbar(context, 'Konten tidak valid untuk di-assign.');
      return;
    }
    if (kontenStatus != 'published') {
      context.showErrorSnackbar(
        context,
        'Konten draft belum bisa di-assign. Publish via Admin terlebih dahulu.',
      );
      return;
    }

    final pasienFuture = ref.read(
      fetchPasienListByDokterIdProvider(dokterId: dokterUid).future,
    );
    final selectedPasienIds = <String>{};
    bool isSubmitting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Assign Konten ke Pasien'),
              content: FutureBuilder<List<PasienProfileModel>?>(
                future: pasienFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 96,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final pasienList =
                      snapshot.data ?? const <PasienProfileModel>[];
                  if (pasienList.isEmpty) {
                    return const Text(
                      'Belum ada pasien yang ter-assign ke Anda.',
                    );
                  }

                  return SizedBox(
                    width: 420,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedPasienIds.length} pasien dipilih',
                          style: const TextStyle(
                            fontSize: 12,
                            color: UiPalette.slate600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(UiSpacing.xs),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 280),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: pasienList.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final pasien = pasienList[index];
                              final pasienId =
                                  (pasien.uid ?? '').toString().trim();
                              final nama = (pasien.namaLengkap ?? 'Pasien')
                                  .toString()
                                  .trim();
                              final rm = (pasien.noRekamMedis ?? '-')
                                  .toString()
                                  .trim();
                              final isSelected =
                                  selectedPasienIds.contains(pasienId);
                              return CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                value: isSelected,
                                title: Text('$nama (RM: $rm)'),
                                onChanged: isSubmitting
                                    ? null
                                    : (checked) {
                                        setDialogState(() {
                                          if ((checked ?? false) == true) {
                                            selectedPasienIds.add(pasienId);
                                          } else {
                                            selectedPasienIds.remove(pasienId);
                                          }
                                        });
                                      },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (selectedPasienIds.isEmpty) {
                            context.showErrorSnackbar(
                              context,
                              'Pilih minimal 1 pasien terlebih dahulu.',
                            );
                            return;
                          }

                          setDialogState(() {
                            isSubmitting = true;
                          });

                          final now = DateTime.now();
                          final notifier =
                              ref.read(postCreateAssignmentProvider.notifier);
                          var successCount = 0;
                          var failedCount = 0;

                          for (final pasienId in selectedPasienIds) {
                            await notifier.postCreateAssignmen(
                              assignment: KontenAssignmentModel(
                                id: '${kontenId}_$pasienId',
                                pasienId: pasienId,
                                kontenId: kontenId,
                                assignedBy: dokterUid,
                                assignedAt: now,
                                updatedAt: now,
                              ),
                              onSuccess: (_) {
                                successCount++;
                              },
                              onError: (_) {
                                failedCount++;
                              },
                            );
                          }

                          if (Navigator.of(dialogContext).canPop()) {
                            Navigator.of(dialogContext).pop();
                          }
                          if (failedCount == 0) {
                            context.showSuccessDialog(
                              context,
                              'Konten berhasil di-assign ke $successCount pasien.',
                            );
                          } else if (successCount > 0) {
                            context.showSuccessDialog(
                              context,
                              'Berhasil assign $successCount pasien, gagal $failedCount pasien.',
                            );
                          } else {
                            context.showErrorSnackbar(
                              context,
                              'Assign konten gagal. Coba lagi.',
                            );
                          }

                          ref.invalidate(
                            fetchKontenByDokterIdProvider(dokterId: dokterUid),
                          );
                          ref.invalidate(
                            _activeAssignmentCountByKontenProvider(
                              '$dokterUid::$kontenId',
                            ),
                          );

                          if (dialogContext.mounted) {
                            setDialogState(() {
                              isSubmitting = false;
                            });
                          }
                        },
                  child: Text(isSubmitting ? 'Menyimpan...' : 'Assign'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDeleteButton(
    BuildContext context,
    WidgetRef ref, {
    bool fullWidth = false,
  }) {
    return OutlinedButton.icon(
      onPressed: () => context.showDeleteContentDialog(
        onConfirm: () {
          ref.read(putKontenProvider.notifier).putKonten(
                kontenId: konten.id ?? '',
                onSuccess: (_) {
                  context.showSuccessDialog(
                      context, 'Konten berhasil dihapus.');
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid != null) {
                    ref.invalidate(
                        fetchKontenByDokterIdProvider(dokterId: uid));
                  }
                },
                onError: (message) {
                  context.showErrorSnackbar(context, message);
                },
              );
        },
      ),
      icon: const Icon(Icons.delete_outline, size: 14),
      label: const Text(
        'Hapus',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: UiPalette.red600,
        side: const BorderSide(color: Color(0xFFFECACA)),
        minimumSize: Size(fullWidth ? double.infinity : 0, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildManageAssignmentButton(
    BuildContext context,
    WidgetRef ref, {
    bool fullWidth = false,
  }) {
    return OutlinedButton.icon(
      onPressed: () => _showManageAssignmentDialog(context, ref),
      icon: const Icon(Icons.manage_accounts_outlined, size: 14),
      label: const Text(
        'Kelola',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: UiPalette.slate700,
        side: const BorderSide(color: Color(0xFFD1D5DB)),
        minimumSize: Size(fullWidth ? double.infinity : 0, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _showManageAssignmentDialog(
      BuildContext context, WidgetRef ref) async {
    final dokterUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final kontenId = (konten.id ?? '').trim();
    if (dokterUid.isEmpty || kontenId.isEmpty) {
      context.showErrorSnackbar(context, 'Data dokter/konten tidak valid.');
      return;
    }

    final repository = ref.read(assignmentRepositoryProvider);
    final pasienFuture = ref.read(
      fetchPasienListByDokterIdProvider(dokterId: dokterUid).future,
    );
    final assignmentFuture = repository.getAssignmentsByDokterAndKonten(
      dokterId: dokterUid,
      kontenId: kontenId,
    );

    final selectedForCancel = <String>{};
    bool isSubmitting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Kelola Assignment'),
              content: FutureBuilder<List<dynamic>>(
                future: Future.wait([pasienFuture, assignmentFuture]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Text('Gagal memuat data assignment.');
                  }

                  final pasienList =
                      (snapshot.data![0] as List<PasienProfileModel>?) ??
                          const <PasienProfileModel>[];
                  final assignmentsResult = snapshot.data![1] as dynamic;
                  final assignments = assignmentsResult.fold(
                    (_) => <KontenAssignmentModel>[],
                    (data) => data as List<KontenAssignmentModel>,
                  ) as List<KontenAssignmentModel>;

                  if (assignments.isEmpty) {
                    return const Text(
                        'Belum ada assignment aktif pada konten ini.');
                  }

                  final pasienById = {
                    for (final p in pasienList) (p.uid ?? '').trim(): p,
                  };

                  return SizedBox(
                    width: 430,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${assignments.length} pasien aktif',
                          style: const TextStyle(
                            fontSize: 12,
                            color: UiPalette.slate600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(UiSpacing.xs),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: assignments.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final assignment = assignments[index];
                              final pasien = pasienById[assignment.pasienId];
                              final nama =
                                  (pasien?.namaLengkap ?? 'Pasien').trim();
                              final rm = (pasien?.noRekamMedis ?? '-').trim();
                              final isChecked = selectedForCancel
                                  .contains(assignment.pasienId);
                              return CheckboxListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                value: isChecked,
                                title: Text('$nama (RM: $rm)'),
                                onChanged: isSubmitting
                                    ? null
                                    : (checked) {
                                        setDialogState(() {
                                          if ((checked ?? false) == true) {
                                            selectedForCancel
                                                .add(assignment.pasienId);
                                          } else {
                                            selectedForCancel
                                                .remove(assignment.pasienId);
                                          }
                                        });
                                      },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Tutup'),
                ),
                OutlinedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setDialogState(() {
                            isSubmitting = true;
                          });
                          final result =
                              await repository.cancelAllAssignmentsByKonten(
                            dokterId: dokterUid,
                            kontenId: kontenId,
                          );
                          result.fold(
                            (error) =>
                                context.showErrorSnackbar(context, error),
                            (message) =>
                                context.showSuccessDialog(context, message),
                          );
                          if (Navigator.of(dialogContext).canPop()) {
                            Navigator.of(dialogContext).pop();
                          }
                          ref.invalidate(
                            fetchKontenByDokterIdProvider(dokterId: dokterUid),
                          );
                          ref.invalidate(
                            _activeAssignmentCountByKontenProvider(
                              '$dokterUid::$kontenId',
                            ),
                          );
                        },
                  child: const Text('Batalkan Semua'),
                ),
                FilledButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (selectedForCancel.isEmpty) {
                            context.showErrorSnackbar(
                              context,
                              'Pilih minimal 1 pasien untuk dibatalkan.',
                            );
                            return;
                          }
                          setDialogState(() {
                            isSubmitting = true;
                          });
                          final result = await repository.cancelAssignments(
                            dokterId: dokterUid,
                            kontenId: kontenId,
                            pasienIds: selectedForCancel.toList(),
                          );
                          result.fold(
                            (error) =>
                                context.showErrorSnackbar(context, error),
                            (message) =>
                                context.showSuccessDialog(context, message),
                          );
                          if (Navigator.of(dialogContext).canPop()) {
                            Navigator.of(dialogContext).pop();
                          }
                          ref.invalidate(
                            fetchKontenByDokterIdProvider(dokterId: dokterUid),
                          );
                          ref.invalidate(
                            _activeAssignmentCountByKontenProvider(
                              '$dokterUid::$kontenId',
                            ),
                          );
                        },
                  child:
                      Text(isSubmitting ? 'Memproses...' : 'Batalkan Terpilih'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

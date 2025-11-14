import 'package:aconsia_app/presentation/pasien/home/widgets/tag_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DetailKontenWidget extends StatelessWidget {
  final String? jenisOperasi;
  final String? jenisAnestesi;
  final bool isRekomendasi;
  final double? skorPemahamanAI;
  final bool isSelesai;

  const DetailKontenWidget({
    super.key,
    this.jenisOperasi,
    this.jenisAnestesi,
    this.isRekomendasi = false,
    this.skorPemahamanAI,
    this.isSelesai = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rekomendasi Tag
          if (isRekomendasi) ...[
            RekomendasiTag(),
            Gap(8),
          ],

          // Jenis Anestesi Tag
          if (jenisAnestesi != null) ...[
            JenisAnestesiTag(text: jenisAnestesi!),
            Gap(8),
          ],

          // Jenis Operasi Tag
          if (jenisOperasi != null) ...[
            JenisOperasiTag(text: jenisOperasi!),
            Gap(8),
          ],

          // Skor Pemahaman AI Tag
          if (skorPemahamanAI != null) ...[
            SkorPemahamanAITag(skor: skorPemahamanAI!),
            Gap(8),
          ],

          // Status Selesai Tag
          if (isSelesai) ...[
            StatusSelesaiTag(),
          ],
        ],
      ),
    );
  }
}

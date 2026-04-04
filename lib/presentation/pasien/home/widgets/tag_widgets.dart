import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

/// 🌟 Rekomendasi Tag
class RekomendasiTag extends StatelessWidget {
  const RekomendasiTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: UiPalette.blue600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.icons.icStar.path,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          const Gap(4),
          const Text(
            'Rekomendasi',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// 💉 Jenis Anestesi Tag
class JenisAnestesiTag extends StatelessWidget {
  final String text;

  const JenisAnestesiTag({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: UiPalette.slate300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 🏥 Jenis Operasi Tag
class JenisOperasiTag extends StatelessWidget {
  final String text;

  const JenisOperasiTag({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: UiPalette.blue50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: UiPalette.blue600,
        ),
      ),
    );
  }
}

/// ⚙️ Tata Cara Tag
class TataCaraTag extends StatelessWidget {
  final String text;

  const TataCaraTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0077B6),
        ),
      ),
    );
  }
}

/// 🚨 Komplikasi Tag
class KomplikasiTag extends StatelessWidget {
  final String text;

  const KomplikasiTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFD90429),
        ),
      ),
    );
  }
}

/// 🧭 Indikasi Tindakan Tag
class IndikasiTindakanTag extends StatelessWidget {
  final String text;

  const IndikasiTindakanTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE6FFEA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF008C45),
        ),
      ),
    );
  }
}

/// 🔮 Prognosis Tag
class PrognosisTag extends StatelessWidget {
  final String text;

  const PrognosisTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFECE3FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5B00B6),
        ),
      ),
    );
  }
}

/// 🔄 Alternatif Lain Tag
class AlternatifLainTag extends StatelessWidget {
  final String text;

  const AlternatifLainTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFD4A017),
        ),
      ),
    );
  }
}

/// 🧠 Skor Pemahaman AI Tag
class SkorPemahamanAITag extends StatelessWidget {
  final double skor;

  const SkorPemahamanAITag({
    super.key,
    required this.skor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: UiPalette.blue50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.psychology,
            size: 14,
            color: UiPalette.blue600,
          ),
          const Gap(4),
          Text(
            'AI Score: ${skor.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: UiPalette.blue600,
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Status Selesai Tag
class StatusSelesaiTag extends StatelessWidget {
  const StatusSelesaiTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: UiPalette.emerald50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Selesai',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: UiPalette.emerald600,
        ),
      ),
    );
  }
}

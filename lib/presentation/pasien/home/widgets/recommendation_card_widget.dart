import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/ai_recommendation_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/tag_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RecommendationCardWidget extends StatelessWidget {
  final RecommendationItem recommendation;

  const RecommendationCardWidget({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    final konten = recommendation.konten;
    final relevanceScore = recommendation.relevanceScore;

    return InkWell(
      onTap: () {
        context.pushNamed(RouteName.detailKonten, extra: konten.id);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(UiSpacing.md),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [UiPalette.blue50, UiPalette.white],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: UiPalette.blue100, width: 1.25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRelevanceColor(relevanceScore),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome,
                          size: 14, color: Colors.white),
                      const Gap(4),
                      Text(
                        '${relevanceScore.toInt()}% Match',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: UiPalette.amber50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: UiPalette.amber100),
                  ),
                  child: const Text(
                    'Belum Dibaca',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: UiPalette.amber600,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(UiSpacing.md),
            Text(
              konten.judul ?? 'Judul tidak tersedia',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: UiPalette.slate900,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(UiSpacing.sm),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (konten.jenisAnestesi != null)
                  JenisAnestesiTag(text: konten.jenisAnestesi!),
                if (konten.tataCara != null)
                  TataCaraTag(text: konten.tataCara!),
              ],
            ),
            const Gap(UiSpacing.md),
            Container(
              padding: const EdgeInsets.all(UiSpacing.sm),
              decoration: BoxDecoration(
                color: UiPalette.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: UiPalette.slate200),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: UiPalette.blue600,
                  ),
                  const Gap(UiSpacing.sm),
                  Expanded(
                    child: Text(
                      recommendation.reason,
                      style: const TextStyle(
                        fontSize: 12,
                        color: UiPalette.slate700,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRelevanceColor(double score) {
    if (score >= 80) {
      return UiPalette.emerald600;
    } else if (score >= 60) {
      return UiPalette.blue600;
    }
    return UiPalette.amber600;
  }
}

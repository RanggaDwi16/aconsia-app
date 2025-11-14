import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
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
        context.pushNamed(
          RouteName.detailKonten,
          extra: konten.id,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColor.primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with relevance score
            Row(
              children: [
                // Relevance badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getRelevanceColor(relevanceScore),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 14,
                        color: Colors.white,
                      ),
                      const Gap(4),
                      Text(
                        '${relevanceScore.toInt()}% Match',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // New badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.shade200,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Belum Dibaca',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),

            // Title
            Text(
              konten.judul ?? 'Judul tidak tersedia',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(8),

            // Tags
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
            const Gap(12),

            // Reason
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      recommendation.reason,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
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
      return Colors.green;
    } else if (score >= 60) {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }
}

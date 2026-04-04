import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/ai_recommendation_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/recommendation_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AiRecommendationWidget extends ConsumerWidget {
  const AiRecommendationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final recommendationsAsync = ref.watch(
      fetchAiRecommendationsProvider(pasienId: uid, limit: 3),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              Assets.icons.icStar.path,
              width: 20,
              height: 20,
            ),
            const Gap(8),
            const Text(
              'Rekomendasi AI',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: UiPalette.slate900,
              ),
            ),
          ],
        ),
        const Gap(8),
        const Text(
          'Berdasarkan progress Anda, kami merekomendasikan materi:',
          style: TextStyle(
            fontSize: 14,
            color: UiPalette.slate500,
          ),
        ),
        const Gap(16),

        // Recommendations content
        recommendationsAsync.when(
          data: (recommendations) {
            if (recommendations.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                ...recommendations.map((recommendation) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RecommendationCardWidget(
                      recommendation: recommendation,
                    ),
                  );
                }),
                const Gap(8),
                // "Lihat Semua" button
                Button.outlined(
                  onPressed: () {
                    context.pushNamed(RouteName.allRecommendations);
                  },
                  label: 'Lihat Semua Rekomendasi',
                  width: double.infinity,
                ),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => _buildEmptyState(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return AconsiaCardSurface(
      padding: const EdgeInsets.all(24),
      borderColor: UiPalette.slate200,
      child: Column(
        children: [
          const Icon(
            Icons.star_border,
            size: 48,
            color: UiPalette.slate400,
          ),
          const Gap(12),
          Text(
            'Belum Ada Rekomendasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: UiPalette.slate700,
            ),
          ),
          const Gap(6),
          Text(
            'Selesaikan sesi AI pembelajaran untuk mendapatkan rekomendasi konten yang sesuai',
            style: TextStyle(
              fontSize: 13,
              color: UiPalette.slate600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/ai_recommendation_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/widgets/recommendation_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AllRecommendationsPage extends ConsumerStatefulWidget {
  const AllRecommendationsPage({super.key});

  @override
  ConsumerState<AllRecommendationsPage> createState() =>
      _AllRecommendationsPageState();
}

class _AllRecommendationsPageState
    extends ConsumerState<AllRecommendationsPage> {
  String _selectedFilter = 'all';
  final String _selectedSort = 'relevance';

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('User tidak terautentikasi')),
      );
    }

    final recommendationsAsync = ref.watch(
      fetchAllUnreadKontenProvider(pasienId: uid),
    );

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [UiPalette.blue50, UiPalette.white],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(UiSpacing.md, UiSpacing.sm,
                  UiSpacing.md, UiSpacing.xs),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: UiPalette.slate600,
                  ),
                  const Expanded(
                    child: Text(
                      'Rekomendasi AI',
                      style: UiTypography.title,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                UiSpacing.md,
                UiSpacing.sm,
                UiSpacing.md,
                0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('all', 'Semua'),
                    const Gap(UiSpacing.sm),
                    _buildFilterChip('high', 'Sangat Relevan'),
                    const Gap(UiSpacing.sm),
                    _buildFilterChip('medium', 'Relevan'),
                    const Gap(UiSpacing.sm),
                    _buildFilterChip('low', 'Cukup Relevan'),
                  ],
                ),
              ),
            ),
            const Gap(UiSpacing.sm),
            Expanded(
              child: recommendationsAsync.when(
                data: (recommendations) {
                  if (recommendations.isEmpty) {
                    return _buildEmptyState();
                  }

                  var filteredRecommendations = _filterRecommendations(
                    recommendations,
                    _selectedFilter,
                  );

                  filteredRecommendations = _sortRecommendations(
                    filteredRecommendations,
                    _selectedSort,
                  );

                  if (filteredRecommendations.isEmpty) {
                    return _buildNoResultsState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(fetchAllUnreadKontenProvider);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(UiSpacing.md),
                      itemCount: filteredRecommendations.length,
                      separatorBuilder: (context, index) =>
                          const Gap(UiSpacing.md),
                      itemBuilder: (context, index) {
                        final recommendation = filteredRecommendations[index];
                        return RecommendationCardWidget(
                          recommendation: recommendation,
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => _buildErrorState(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: UiPalette.blue100,
      checkmarkColor: UiPalette.blue600,
      labelStyle: TextStyle(
        color: isSelected ? UiPalette.blue600 : UiPalette.slate600,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 12,
      ),
      side: BorderSide(
        color: isSelected ? UiPalette.blue500 : UiPalette.slate300,
      ),
      backgroundColor: UiPalette.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  List<RecommendationItem> _filterRecommendations(
    List<RecommendationItem> recommendations,
    String filter,
  ) {
    switch (filter) {
      case 'high':
        return recommendations.where((r) => r.relevanceScore >= 80).toList();
      case 'medium':
        return recommendations
            .where((r) => r.relevanceScore >= 60 && r.relevanceScore < 80)
            .toList();
      case 'low':
        return recommendations.where((r) => r.relevanceScore < 60).toList();
      default:
        return recommendations;
    }
  }

  List<RecommendationItem> _sortRecommendations(
    List<RecommendationItem> recommendations,
    String sortBy,
  ) {
    final sorted = List<RecommendationItem>.from(recommendations);
    switch (sortBy) {
      case 'relevance':
        sorted.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
        break;
      case 'newest':
        sorted.sort((a, b) {
          final dateA = a.konten.createdAt ?? DateTime(2000);
          final dateB = b.konten.createdAt ?? DateTime(2000);
          return dateB.compareTo(dateA);
        });
        break;
    }
    return sorted;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.xl),
        child: AconsiaCardSurface(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.task_alt, size: 64, color: UiPalette.emerald600),
              const Gap(UiSpacing.md),
              const Text(
                'Semua Materi Sudah Dibaca',
                style: UiTypography.title,
              ),
              const Gap(UiSpacing.sm),
              const Text(
                'Belum ada rekomendasi baru untuk saat ini.',
                style: UiTypography.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.xl),
        child: AconsiaCardSurface(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.filter_alt_off,
                  size: 64, color: UiPalette.slate400),
              const Gap(UiSpacing.md),
              const Text(
                'Filter Tidak Menemukan Hasil',
                style: UiTypography.title,
                textAlign: TextAlign.center,
              ),
              const Gap(UiSpacing.sm),
              const Text(
                'Coba ganti filter untuk melihat rekomendasi lainnya.',
                style: UiTypography.body,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiSpacing.xl),
        child: AconsiaCardSurface(
          borderColor: UiPalette.red600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 64, color: UiPalette.red600),
              const Gap(UiSpacing.md),
              const Text(
                'Terjadi Kesalahan',
                style: UiTypography.title,
              ),
              const Gap(UiSpacing.sm),
              Text(
                error,
                style: UiTypography.body.copyWith(color: UiPalette.red600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

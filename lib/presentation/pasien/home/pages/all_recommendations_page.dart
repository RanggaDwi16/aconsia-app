import 'package:aconsia_app/core/utils/constant/app_colors.dart';
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
  String _selectedSort = 'relevance';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Rekomendasi AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        actions: [
          // Sort menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _selectedSort = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'relevance',
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 18),
                    Gap(8),
                    Text('Relevansi'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'newest',
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 18),
                    Gap(8),
                    Text('Terbaru'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', 'Semua'),
                  const Gap(8),
                  _buildFilterChip('high', 'Sangat Relevan'),
                  const Gap(8),
                  _buildFilterChip('medium', 'Relevan'),
                  const Gap(8),
                  _buildFilterChip('low', 'Cukup Relevan'),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: recommendationsAsync.when(
              data: (recommendations) {
                if (recommendations.isEmpty) {
                  return _buildEmptyState();
                }

                // Apply filters
                var filteredRecommendations = _filterRecommendations(
                  recommendations,
                  _selectedFilter,
                );

                // Apply sorting
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
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecommendations.length,
                    separatorBuilder: (context, index) => const Gap(12),
                    itemBuilder: (context, index) {
                      final recommendation = filteredRecommendations[index];
                      return RecommendationCardWidget(
                        recommendation: recommendation,
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const Gap(16),
                    Text(
                      'Terjadi kesalahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const Gap(8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      selectedColor: AppColor.primaryColor.withOpacity(0.2),
      checkmarkColor: AppColor.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppColor.primaryColor : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColor.primaryColor : Colors.grey[300]!,
      ),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green[300],
            ),
            const Gap(24),
            Text(
              'Selamat!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Gap(8),
            Text(
              'Kamu sudah menyelesaikan semua konten pembelajaran yang tersedia',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const Gap(16),
            Text(
              'Tidak ada konten dengan filter ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              'Coba ubah filter untuk melihat konten lainnya',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

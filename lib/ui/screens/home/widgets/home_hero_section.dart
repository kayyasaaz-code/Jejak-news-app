import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/theme/app_theme.dart';
import 'package:news_app/providers/navigation_provider.dart';
import 'package:news_app/providers/rencanaku_provider.dart';

class HomeHeroSection extends ConsumerWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(rencanakuProvider);

    int totalTasks = 0;
    int completedTasks = 0;
    for (final plan in plans) {
      totalTasks += plan.checklist.length;
      completedTasks += plan.completedCount;
    }
    final int percent = totalTasks == 0
        ? 0
        : ((completedTasks / totalTasks) * 100).round();

    final activePlan = plans.isNotEmpty ? plans.first : null;
    final nextTask = activePlan?.checklist
        .where((item) => !item.isCompleted)
        .firstOrNull;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Row(
        children: [
          // KARTU KIRI: Botanical Sage (Progress Rencanaku - Gaya kartu "86% battery / Health")
          Expanded(
            flex: 11,
            child: GestureDetector(
              onTap: () =>
                  ref.read(navigationProvider.notifier).goToRencanaku(),
              child: Container(
                height: 156,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.sageGreen,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Pill dengan garis tipis 1px khas referensi
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.ink.withValues(alpha: 0.45),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Rencanaku',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.north_east_rounded,
                          size: 16,
                          color: AppColors.ink,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plans.isEmpty ? '0' : '$percent%',
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          plans.isEmpty
                              ? 'Belum ada target'
                              : (nextTask?.title ??
                                    '$completedTasks/$totalTasks langkah'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.ink.withValues(alpha: 0.78),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // KARTU KANAN: Glaze Blue (Jelajahi Peluang - Gaya kartu "Challenge With Pro Coach")
          Expanded(
            flex: 12,
            child: GestureDetector(
              onTap: () => ref.read(navigationProvider.notifier).goToExplore(),
              child: Container(
                height: 156,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.glazeBlue,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.glazeBlueInk.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Explore',
                        style: TextStyle(
                          color: AppColors.glazeBlueInk,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Text(
                      'Cari beasiswa &\nlomba baru',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardWhite,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Mulai',
                                style: TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.play_arrow_rounded,
                                size: 14,
                                color: AppColors.ink,
                              ),
                            ],
                          ),
                        ),
                      ],
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
}

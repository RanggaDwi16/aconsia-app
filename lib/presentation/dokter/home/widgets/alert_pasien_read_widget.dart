import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';

class AlertPasienReadWidget extends StatelessWidget {
  final int activeReaderCount;
  final VoidCallback? onTap;

  const AlertPasienReadWidget({
    super.key,
    required this.activeReaderCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7EB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFED7AA)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEDD5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFFB45309),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aktivitas Real-Time',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7C2D12),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$activeReaderCount pasien sedang membaca materi saat ini',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColor.textGrayColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9A3412),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

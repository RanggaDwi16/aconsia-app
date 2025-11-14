import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HasilChatAiPage extends StatelessWidget {
  const HasilChatAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hasil Kuis',
        centertitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(context.deviceHeight * 0.05),
              SvgPicture.asset(
                Assets.icons.icDone.path,
              ),
              Gap(12),
              Text(
                'Yeay, selamat kamu telah menyelesaikan materi ini',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Skor pemahaman: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.textGrayColor,
                    ),
                  ),
                  Text(
                    '88%',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Gap(24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.borderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Assets.icons.icRingDonw.path,
                          colorFilter: const ColorFilter.mode(
                            AppColor.primaryGreen,
                            BlendMode.srcIn,
                          ),
                        ),
                        Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tips untuk Anda',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Gap(4),
                              Text(
                                'Berikut adalah beberapa tips untuk meningkatkan pemahaman Anda:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textGrayColor,
                                ),
                              ),
                              Gap(12),

                              // Item 1
                              Text(
                                'Mengetahui Fungsi Anestesi Regional',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Gap(6),
                              Text(
                                'Pasien memahami bahwa anestesi regional membuat bagian tubuh tertentu mati rasa tanpa membuatnya tertidur total, sehingga tetap sadar namun tidak merasakan nyeri selama prosedur.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textGrayColor,
                                ),
                              ),
                              Gap(12),

                              // Item 2
                              Text(
                                'Menyadari Pentingnya Persiapan Sebelum Tindakan',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Gap(6),
                              Text(
                                'Pasien mengerti pentingnya pemeriksaan awal, seperti riwayat alergi dan kondisi kesehatan, untuk memastikan anestesi berjalan aman dan efektif.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textGrayColor,
                                ),
                              ),
                              Gap(12),

                              // Item 3
                              Text(
                                'Memahami Risiko dan Manfaat Anestesi',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Gap(6),
                              Text(
                                'Pasien menyadari adanya risiko dan manfaat dari penggunaan anestesi, termasuk kemungkinan efek samping dan keuntungan dalam mengurangi rasa sakit selama dan setelah prosedur.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textGrayColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Button.outlined(
                onPressed: () => context.pop(),
                label: 'Belajar Lagi',
              ),
            ),
            Gap(8),
            Expanded(
              child: Button.filled(
                onPressed: () => context.pop(),
                label: 'Selesai',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

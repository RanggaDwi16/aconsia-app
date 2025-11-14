import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ACONSIA',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondTextColor,
                        ),
                      ),
                      Gap(8),
                      Text(
                        'Menjelaskan dengan Hati, Menjalankan dengan Ilmu.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.textGrayColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gap(36),
                      Text(
                        'Platform Edukasi Anestesi Digital',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(8),
                      Text(
                        'Menghubungkan dokter dan pasien untuk memahami prosedur anestesi dengan lebih baik sebelum operasi',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.textGrayColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gap(32),
                      Button.filled(
                        onPressed: () =>
                            context.pushNamed(RouteName.loginDokter),
                        label: 'Masuk Sebagai Dokter',
                      ),
                      Gap(16),
                      Button.outlined(
                        onPressed: () =>
                            context.pushNamed(RouteName.loginPasien),
                        label: 'Masuk Sebagai Pasien',
                      ),
                      Gap(16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Butuh Bantuan?',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Gap(10),
                          InkWell(
                            onTap: () => context.pushNamed(RouteName.helpdesk),
                            child: Text(
                              'Tutorial',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

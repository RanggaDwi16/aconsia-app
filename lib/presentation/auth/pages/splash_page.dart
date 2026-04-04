import 'dart:async';

import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_brand_logo.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      context.go(RouteName.welcome);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AconsiaBrandLogo(size: 92, imageSize: 58),
                      const SizedBox(height: 16),
                      Text(
                        'ACONSIA',
                        style: UiTypography.display.copyWith(
                          color: UiPalette.blue600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Menjelaskan dengan Hati, Menjalankan dengan Ilmu.',
                        style: UiTypography.body,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              StreamBuilder<int>(
                stream: Stream.periodic(
                    const Duration(milliseconds: 400), (i) => i),
                builder: (context, snapshot) {
                  final tick = snapshot.data ?? 0;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final visibleStage = tick % 3;
                      final opacity = (visibleStage == i) ? 1.0 : 0.35;
                      return AnimatedOpacity(
                        opacity: opacity,
                        duration: const Duration(milliseconds: 300),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: SizedBox(
                            width: 10,
                            height: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: UiPalette.blue600,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              const Gap(16),
              SafeArea(
                bottom: true,
                top: false,
                child: const Text(
                  'Platform Edukasi Anestesi Digital',
                  style: UiTypography.caption,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/presentation/pasien/home/pages/home_pasien_page.dart';
import 'package:aconsia_app/presentation/pasien/konten/pages/konten_pasien_page.dart';
import 'package:aconsia_app/presentation/pasien/profile/pages/profile_pasien_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../controllers/selected_index_provider.dart';

class MainPasienPage extends ConsumerWidget {
  const MainPasienPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexPasienProvider);

    final List<Widget> pages = [
      HomePasienPage(),
      KontenPasienPage(),
      ProfilePasienPage(),
    ];

    final icons = [
      [Assets.icons.icHome, Assets.icons.icHome],
      [Assets.icons.icKonten, Assets.icons.icKonten],
      [Assets.icons.icPerson, Assets.icons.icPerson],
    ];

    final labels = [
      'Home',
      'Konten',
      'Profile',
    ];

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: selectedIndex,
          selectedItemColor: AppColor.primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            ref.read(selectedIndexPasienProvider.notifier).state = index;
          },
          items: List.generate(icons.length, (index) {
            final isSelected = selectedIndex == index;
            return BottomNavigationBarItem(
              icon: SvgPicture.asset(
                isSelected ? icons[index][1].path : icons[index][0].path,
                width: 24,
                height: 24,
                color: isSelected
                    ? AppColor.primaryColor
                    : Colors.grey, // warna ikon saat aktif
              ),
              label: labels[index],
            );
          }),
        ),
      ),
    );
  }
}

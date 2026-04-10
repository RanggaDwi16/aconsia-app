import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/presentation/dokter/home/pages/home_page.dart';
import 'package:aconsia_app/presentation/dokter/home/pages/list_active_pasien_page.dart';
import 'package:aconsia_app/presentation/dokter/konten/pages/konten_page.dart';
import 'package:aconsia_app/presentation/dokter/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/pages/profile_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainDokterPage extends ConsumerWidget {
  const MainDokterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    final List<Widget> pages = [
      HomePage(),
      ProfilePage(),
      ListActivePasienPage(embeddedInMainNav: true),
      KontenPage(),
    ];

    final icons = [
      [Assets.icons.icHome, Assets.icons.icHome],
      [Assets.icons.icPerson, Assets.icons.icPerson],
      [Assets.icons.icPeoples, Assets.icons.icPeoples],
      [Assets.icons.icKonten, Assets.icons.icKonten],
    ];

    final labels = [
      'Dashboard',
      'Profil Saya',
      'Pasien Saya',
      'Konten Edukasi',
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
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          elevation: 6,
          selectedItemColor: UiPalette.blue600,
          unselectedItemColor: UiPalette.slate400,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10.5,
          ),
          onTap: (index) {
            ref.read(selectedIndexProvider.notifier).state = index;
          },
          items: List.generate(icons.length, (index) {
            final isSelected = selectedIndex == index;
            return BottomNavigationBarItem(
              icon: SvgPicture.asset(
                isSelected ? icons[index][1].path : icons[index][0].path,
                width: 24,
                height: 24,
                color: isSelected ? UiPalette.blue600 : UiPalette.slate400,
              ),
              label: labels[index],
            );
          }),
        ),
      ),
    );
  }
}

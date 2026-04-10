import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/presentation/chat/pages/dokter_pasien_chat_page.dart';
import 'package:aconsia_app/presentation/pasien/assessment/pages/pre_operative_assessment_page.dart';
import 'package:aconsia_app/presentation/pasien/home/pages/home_pasien_page.dart';
import 'package:aconsia_app/presentation/pasien/konten/pages/chat_ai_page.dart';
import 'package:aconsia_app/presentation/pasien/konten/pages/konten_pasien_page.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/widgets/pasien_main_shell_scope.dart';
import 'package:aconsia_app/presentation/pasien/main/widgets/pasien_sidebar_drawer.dart';
import 'package:aconsia_app/presentation/pasien/profile/pages/profile_pasien_page.dart';
import 'package:aconsia_app/presentation/pasien/schedule/pages/schedule_signature_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPasienPage extends ConsumerStatefulWidget {
  const MainPasienPage({super.key});

  @override
  ConsumerState<MainPasienPage> createState() => _MainPasienPageState();
}

class _MainPasienPageState extends ConsumerState<MainPasienPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final rawSelectedIndex = ref.watch(selectedIndexPasienProvider);
    final selectedIndex = rawSelectedIndex.clamp(0, 6);

    if (rawSelectedIndex != selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedIndexPasienProvider.notifier).state = selectedIndex;
      });
    }

    final pages = <Widget>[
      const HomePasienPage(),
      const ProfilePasienPage(),
      const PreOperativeAssessmentPage(),
      const KontenPasienPage(),
      const ChatAiPage(),
      const DokterPasienChatPage(
        role: 'pasien',
        embeddedInMainShell: true,
      ),
      const ScheduleSignaturePage(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: UiPalette.white,
      drawer: PasienSidebarDrawer(selectedIndex: selectedIndex),
      body: PasienMainShellScope(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
    );
  }
}

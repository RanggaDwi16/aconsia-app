import 'package:aconsia_app/core/routers/go_router_provider.dart';
import 'package:aconsia_app/core/services/app_check_service.dart';
import 'package:aconsia_app/core/utils/constant/app_theme.dart';
import 'package:aconsia_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Aktifkan App Check hanya jika enabled di environment
  final enableAppCheck =
      dotenv.env['ENABLE_APP_CHECK']?.toLowerCase() == 'true';

  // Initialize App Check dengan service
  await AppCheckService.initialize(
    enableAppCheck: enableAppCheck,
    maxRetries: 3,
  );

  // Lock orientasi ke portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Jalankan app
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Aconsia App',
      theme: AppTheme.lightTheme,
      routeInformationParser: ref.watch(routerProvider).routeInformationParser,
      routeInformationProvider:
          ref.watch(routerProvider).routeInformationProvider,
      routerDelegate: ref.watch(routerProvider).routerDelegate,
    );
  }
}

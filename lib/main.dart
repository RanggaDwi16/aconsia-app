import 'package:aconsia_app/core/routers/go_router_provider.dart';
import 'package:aconsia_app/core/services/openai_service.dart';
import 'package:aconsia_app/core/services/app_check_service.dart';
import 'package:aconsia_app/core/utils/constant/app_theme.dart';
import 'package:aconsia_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

const Map<String, String> _defaultEnv = {
  'ENABLE_APP_CHECK': 'false',
  'USE_MOCK_AI': 'true',
  'AI_PROVIDER': 'mock_local',
  'AI_GATEWAY_ENABLED': 'false',
  'AI_GATEWAY_REGION': '',
  'AI_GATEWAY_CALLABLE': '',
  'CLOUDINARY_CLOUD_NAME': '',
  'CLOUDINARY_UPLOAD_PRESET': 'aconsia_app',
};

Future<void> _loadEnvironment() async {
  try {
    // Load raw .env first, then apply defaults ONLY for missing keys.
    // This guarantees .env values (e.g. USE_MOCK_AI=false) are not overridden.
    await dotenv.load(fileName: ".env");
    final merged = <String, String>{
      ..._defaultEnv,
      ...dotenv.env,
    };
    dotenv.testLoad(mergeWith: merged);
    final aiStatus = AiRuntimeStatus.fromEnv(dotenv.env);
    debugPrint(
      '[ENV][AI] USE_MOCK_AI=${dotenv.env['USE_MOCK_AI']} | AI_PROVIDER=${dotenv.env['AI_PROVIDER']} | OPENAI_API_KEY_PRESENT=${aiStatus.apiKeyPresent} | openAiReady=${aiStatus.openAiReady} | reason=${aiStatus.reason}',
    );
    debugPrint('[ENV] Loaded .env successfully');
  } on FileNotFoundError {
    debugPrint('[ENV] .env not found, using safe default env');
    dotenv.testLoad(mergeWith: _defaultEnv);
  } on EmptyEnvFileError {
    debugPrint('[ENV] .env is empty, using safe default env');
    dotenv.testLoad(mergeWith: _defaultEnv);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await _loadEnvironment();

  // Lock orientasi ke portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Jalankan app
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  late Future<void> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _bootstrapCoreServices();
  }

  Future<void> _bootstrapCoreServices() async {
    // Initialize locale data once for all DateFormat usages (e.g. id_ID).
    await initializeDateFormatting('id_ID', null);

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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Aconsia App',
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Menyiapkan aplikasi...'),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Aconsia App',
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 12),
                      const Text(
                        'Inisialisasi aplikasi gagal.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _bootstrapFuture = _bootstrapCoreServices();
                          });
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Aconsia App',
      theme: AppTheme.lightTheme,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routeInformationParser: ref.watch(routerProvider).routeInformationParser,
      routeInformationProvider:
          ref.watch(routerProvider).routeInformationProvider,
      routerDelegate: ref.watch(routerProvider).routerDelegate,
    );
      },
    );
  }
}

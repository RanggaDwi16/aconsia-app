import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/landing_page.dart';
import 'pages/patient_login_page.dart';
import 'pages/doctor_login_page.dart';
import 'pages/patient_dashboard_page.dart';
import 'pages/doctor_dashboard_page.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  await StorageService.init();
  
  // Set portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const AconsiaApp());
}

class AconsiaApp extends StatelessWidget {
  const AconsiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACONSIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Ultra Clean Design Theme
        primaryColor: const Color(0xFF2563EB), // blue-600
        scaffoldBackgroundColor: Colors.white,
        
        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2563EB),
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        
        // Color Scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB), // blue-600
          secondary: const Color(0xFF059669), // emerald-600
        ),
        
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)), // slate-300
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        
        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(56),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Outlined Button Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: Color(0xFFCBD5E1), width: 2),
            minimumSize: const Size.fromHeight(56),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Font
        fontFamily: 'System',
        
        useMaterial3: true,
      ),
      
      // Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/patient-login': (context) => const PatientLoginPage(),
        '/doctor-login': (context) => const DoctorLoginPage(),
        '/patient-dashboard': (context) => const PatientDashboardPage(),
        '/doctor-dashboard': (context) => const DoctorDashboardPage(),
      },
    );
  }
}

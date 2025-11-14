import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// Service untuk mengelola Firebase App Check
class AppCheckService {
  static Future<void> initialize({
    required bool enableAppCheck,
    int maxRetries = 3,
  }) async {
    if (!enableAppCheck) {
      debugPrint('[AppCheck] ⚠️ Disabled via configuration');
      debugPrint('[AppCheck] 💡 Set ENABLE_APP_CHECK=true untuk production');
      return;
    }

    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Delay untuk menghindari rate limiting
        if (retryCount > 0) {
          final delaySeconds =
              (1 << retryCount); // Exponential backoff: 2, 4, 8s
          debugPrint(
              '[AppCheck] 🔄 Retry $retryCount: Waiting ${delaySeconds}s...');
          await Future.delayed(Duration(seconds: delaySeconds));
        }

        // Activate App Check
        await FirebaseAppCheck.instance.activate(
          androidProvider:
              AndroidProvider.debug, // Change to .playIntegrity for production
          appleProvider:
              AppleProvider.debug, // Change to .appAttest for production
          webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
        );

        // Enable auto token refresh
        await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

        debugPrint('[AppCheck] ✅ Initialized successfully');
        return; // Success
      } catch (e) {
        retryCount++;

        if (retryCount >= maxRetries) {
          // Max retries reached
          debugPrint('[AppCheck] ❌ Failed after $maxRetries attempts: $e');
          debugPrint('[AppCheck] ⚠️ Continuing without App Check');
          debugPrint('[AppCheck] 💡 Solutions:');
          debugPrint('[AppCheck]    1. Set ENABLE_APP_CHECK=false in .env');
          debugPrint('[AppCheck]    2. Wait 5-10 minutes for rate limit reset');
          debugPrint('[AppCheck]    3. Clear app data and restart');
        } else {
          debugPrint('[AppCheck] ⚠️ Attempt $retryCount failed: $e');
        }
      }
    }
  }

  /// Get current App Check token (for debugging)
  static Future<String?> getToken() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();
      return token;
    } catch (e) {
      debugPrint('[AppCheck] Error getting token: $e');
      return null;
    }
  }

  /// Check if App Check is properly initialized
  static Future<bool> isInitialized() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

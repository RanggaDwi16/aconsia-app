import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider untuk Firebase Messaging instance
final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

/// Provider untuk mendapatkan FCM token
final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final messaging = ref.watch(firebaseMessagingProvider);

  // Request permission untuk notifications
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Get FCM token
    String? token = await messaging.getToken();
    return token;
  }

  return null;
});

/// Service untuk handle Firebase Cloud Messaging
class FCMService {
  final FirebaseMessaging _messaging;

  FCMService(this._messaging);

  /// Initialize FCM
  Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get FCM token
    String? token = await _messaging.getToken();
    print('🔔 FCM Token: $token');

    // Listen to token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print('🔔 FCM Token Refreshed: $newToken');
    });

    // Setup message handlers
    _setupMessageHandlers();
  }

  /// Setup handlers untuk incoming messages
  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Terminated messages (app terminated, opened from notification)
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(_handleTerminatedMessage);
  }

  /// Handle message saat app di foreground
  void _handleForegroundMessage(RemoteMessage message) {
    print('📬 Foreground Message:');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    // TODO: Show in-app notification atau update UI
    
  }

  /// Handle message saat app di background (user tap notification)
  void _handleBackgroundMessage(RemoteMessage message) {
    print('📬 Background Message (Opened):');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    // TODO: Navigate to specific page based on message.data
  }

  /// Handle message saat app terminated (user tap notification)
  void _handleTerminatedMessage(RemoteMessage? message) {
    if (message == null) return;

    print('📬 Terminated Message (Opened):');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    // TODO: Navigate to specific page based on message.data
  }

  /// Subscribe to topic (untuk group notifications)
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    print('✅ Subscribed to topic: $topic');
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    print('❌ Unsubscribed from topic: $topic');
  }
}

/// Provider untuk FCM Service
final fcmServiceProvider = Provider<FCMService>((ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  return FCMService(messaging);
});

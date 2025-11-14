import 'package:aconsia_app/core/providers/shared_pref_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'token_manager_provider.g.dart';

@riverpod
Future<TokenManager> tokenManager(TokenManagerRef ref) async {
  final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
  return TokenManager(sharedPreferences: sharedPreferences);
}

class TokenManager {
  final SharedPreferences sharedPreferences;

  TokenManager({required this.sharedPreferences});

  // Future<void> saveUser(UserModel user) async {
  //   final userJsonString = jsonEncode(user.toJson()); // Convert to JSON string
  //   await sharedPreferences.setString('user', userJsonString);
  // }

  Future<void> saveToken(String token) async {
    await sharedPreferences.setString('access_token', token);
  }

  Future<void> saveCategoryUser(List<String> categoryIds) async {
    await sharedPreferences.setStringList('category_user', categoryIds);
  }

  Future<void> saveTokenVirtualAccount(String token) async {
    await sharedPreferences.setString('access_token_virtual_account', token);
  }

  Future<void> saveUserId(int userId) async {
    await sharedPreferences.setInt('user_id', userId);
  }

  Future<void> saveRole(String role) async {
    await sharedPreferences.setString('role', role);
  }

  // ==================== AUTH SESSION MANAGEMENT ====================

  /// Save UID from Firebase Auth
  Future<void> saveUid(String uid) async {
    await sharedPreferences.setString('uid', uid);
  }

  /// Get UID
  Future<String?> getUid() async {
    return sharedPreferences.getString('uid');
  }

  /// Save user email
  Future<void> saveEmail(String email) async {
    await sharedPreferences.setString('email', email);
  }

  /// Get user email
  Future<String?> getEmail() async {
    return sharedPreferences.getString('email');
  }

  /// Save user name
  Future<void> saveName(String name) async {
    await sharedPreferences.setString('name', name);
  }

  /// Get user name
  Future<String?> getName() async {
    return sharedPreferences.getString('name');
  }

  /// Get user role
  Future<String?> getRole() async {
    return sharedPreferences.getString('role');
  }

  /// Save profile completion status
  Future<void> saveProfileCompleted(bool isCompleted) async {
    await sharedPreferences.setBool('isProfileCompleted', isCompleted);
  }

  /// Get profile completion status
  Future<bool> isProfileCompleted() async {
    return sharedPreferences.getBool('isProfileCompleted') ?? false;
  }

  /// Save complete user session data
  Future<void> saveUserSession({
    required String uid,
    required String email,
    required String name,
    required String role,
    required bool isProfileCompleted,
  }) async {
    await Future.wait([
      saveUid(uid),
      saveEmail(email),
      saveName(name),
      saveRole(role),
      saveProfileCompleted(isProfileCompleted),
    ]);
  }

  /// Clear user session (logout)
  Future<void> clearUserSession() async {
    await Future.wait([
      sharedPreferences.remove('uid'),
      sharedPreferences.remove('email'),
      sharedPreferences.remove('name'),
      sharedPreferences.remove('role'),
      sharedPreferences.remove('isProfileCompleted'),
      removeToken(),
      removeUser(),
    ]);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final uid = await getUid();
    return uid != null && uid.isNotEmpty;
  }

  // ==================== END AUTH SESSION MANAGEMENT ====================

  // Future<UserModel?> getUser() async {
  //   final userJsonString = sharedPreferences.getString('user');
  //   print('🔍 userJsonString: $userJsonString'); // Cek isi
  //   if (userJsonString == null) return null;

  //   final Map<String, dynamic> userMap = jsonDecode(userJsonString);
  //   print('🔍 userMap: $userMap'); // Cek map-nya
  //   return UserModel.fromJson(userMap);
  // }

  Future<String?> getToken() async {
    final token = sharedPreferences.getString('access_token');
    return token;
  }

  Future<String?> getTokenVirtualAccount() async {
    return sharedPreferences.getString('access_token_virtual_account');
  }

  Future<int?> getUserId() async {
    return sharedPreferences.getInt('user_id');
  }

  Future<List<String>?> getCategoryUser() async {
    return sharedPreferences.getStringList('category_user');
  }

  Future<void> removeToken() async {
    await sharedPreferences.remove('access_token');
  }

  //remove category user
  Future<void> removeCategoryUser() async {
    await sharedPreferences.remove('category_user');
  }

  Future<void> removeTokenVirtualAccount() async {
    await sharedPreferences.remove('access_token_virtual_account');
  }

  Future<void> removeUserId() async {
    await sharedPreferences.remove('user_id');
  }

  //remove user
  Future<void> removeUser() async {
    await sharedPreferences.remove('user');
  }

  Future<void> removeData() async {
    await removeToken();
    await removeUser();
  }

  Future<bool> isLogin() async {
    final token = await getToken();
    if (token == null) {
      return false;
    }
    return true;
  }

  static const String _onboardingKey = 'onboardingCompleted';

  //**🔹 Simpan status bahwa onboarding telah selesai**
  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool(_onboardingKey, true);
  }

  /// **🔹 Periksa apakah onboarding sudah selesai**
  bool isOnboardingCompleted() {
    return sharedPreferences.getBool(_onboardingKey) ?? false;
  }

  // Tambahan baru untuk fingerprint / face ID
  static const String _fingerprintKey = 'fingerprintEnabled';

  /// Simpan apakah user mengaktifkan fingerprint
  Future<void> setFingerprintEnabled(bool enabled) async {
    await sharedPreferences.setBool(_fingerprintKey, enabled);
  }

  /// Ambil status apakah fingerprint aktif
  Future<bool> isFingerprintEnabled() async {
    return sharedPreferences.getBool(_fingerprintKey) ?? false;
  }

  /// Hapus setting fingerprint (misal saat logout)
  Future<void> removeFingerprintEnabled() async {
    await sharedPreferences.remove(_fingerprintKey);
  }
}

// final userFromPrefsProvider = FutureProvider<UserModel?>((ref) async {
//   final prefs = await ref.watch(sharedPreferencesProvider.future);
//   final jsonString = prefs.getString('user');
//   if (jsonString == null) return null;

//   final jsonMap = jsonDecode(jsonString);
//   return UserModel.fromJson(jsonMap);
// });

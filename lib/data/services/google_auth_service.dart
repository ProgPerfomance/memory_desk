import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  // Экземпляр GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// Вход через Google
  Future<Map<String, String>?> signIn() async {
    try {
      // Попытка логина
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        // Пользователь отменил
        return null;
      }

      return {
        "username": account.displayName ?? "",
        "email": account.email,
        "avatar": account.photoUrl ?? "",
      };
    } catch (e) {
      print("Google login error: $e");
      return null;
    }
  }

  /// Выход из Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

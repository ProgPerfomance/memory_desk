import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    // clientId:
    //     "586194623317-gs1u1bi05rkpnsr1tegubsqc247ep1ub.apps.googleusercontent.com", // Android webClientId
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Вход через Google + Firebase
  Future<User?> signIn() async {
    try {
      // 1. Выбор аккаунта Google
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        print("Пользователь отменил вход");
        return null;
      }

      // 2. Получаем токены
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      // 3. Создаём учетные данные для Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Вход в Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      print("Успешный вход: ${userCredential.user?.email}");
      return userCredential.user;
    } catch (e) {
      print("Google login error: $e");
      return null;
    }
  }

  /// Выход
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

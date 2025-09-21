import 'package:memory_desk/data/services/remote_service.dart';

import '../services/google_auth_service.dart';

class UserRepository {
  Future<void> loginUserByEmailAndPassword() async {}

  Future<void> loginUserByGoogle() async {
    try {
      final googleAuth = GoogleAuthService();
      final user = await googleAuth.signIn();
      if (user != null) {
        print("Имя: ${user['username']}");
        print("Email: ${user['email']}");
        print("Аватар: ${user['avatar']}");
        await RemoteService.loginUserByGoogle(
          user['email'] ?? "",
          user['username'] ?? "",
        );
      } else {
        print("Вход отменён");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUserByVk() async {}
}

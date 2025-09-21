import 'package:memory_desk/data/services/remote_service.dart';
import 'package:memory_desk/domain/entities/user_entity.dart';

import '../services/google_auth_service.dart';

class UserRepository {
  UserEntity? _activeUser;

  UserEntity get user => _activeUser!;

  Future<void> loginUserByEmailAndPassword() async {}

  Future<bool> loginUserByGoogle() async {
    try {
      final googleAuth = GoogleAuthService();
      final user = await googleAuth.signIn();
      if (user != null) {
        print("Имя: ${user['username']}");
        print("Email: ${user['email']}");
        print("Аватар: ${user['avatar']}");
        final response = await RemoteService.loginUserByGoogle(
          user['email'] ?? "",
          user['username'] ?? "",
        );
        _activeUser = UserEntity.fromApi(response.data);
        return true;
      } else {
        print("Вход отменён");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> loginUserByVk() async {}
}

import 'package:memory_desk/data/services/remote_service.dart';
import 'package:memory_desk/data/services/user_id_service.dart';
import 'package:memory_desk/domain/entities/user_entity.dart';

import '../services/google_auth_service.dart';

class UserRepository {
  UserEntity? _activeUser;

  UserEntity get user => _activeUser!;

  Future<void> loginUserByEmailAndPassword() async {}

  Future<bool> loginUserByGoogle() async {
    try {
      final googleAuth = GoogleAuthService();
      final u = await googleAuth.signIn();
      if (u != null) {
        print("Имя: ${u['username']}");
        print("Email: ${u['email']}");
        print("Аватар: ${u['avatar']}");
        final response = await RemoteService.loginUserByGoogle(
          u['email'] ?? "",
          u['username'] ?? "",
        );
        _activeUser = UserEntity.fromApi(response.data);
        await UserIdService.saveUserId(user.id);
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

  void updateLocalUserData(UserEntity userData) async {
    _activeUser = userData;
  }
}

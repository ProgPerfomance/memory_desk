import 'package:memory_desk/data/services/remote_service.dart';
import 'package:memory_desk/data/services/user_id_service.dart';
import 'package:memory_desk/domain/entities/user_entity.dart';
import 'package:memory_desk/service_locator.dart';

import '../services/google_auth_service.dart';

class UserRepository {
  UserEntity? _activeUser;

  UserEntity get user => _activeUser!;

  Future<bool> loginUserByEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await RemoteService.loginUserByEmailAndPassword(
        email,
        password,
      );

      if (response.data["e"] != null) {
        return false;
      }

      _activeUser = UserEntity.fromApi(response.data);
      await UserIdService.saveUserId(user.id);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginUserByGoogle() async {
    try {
      final googleAuth = GoogleAuthService();
      final u = await googleAuth.signIn();
      if (u != null) {
        final response = await RemoteService.loginUserByGoogle(
          u.email ?? "",
          u.displayName ?? "",
        );
        _activeUser = UserEntity.fromApi(response.data);
        await UserIdService.saveUserId(user.id);
        return true;
      } else {
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

  Future<void> logout() async {
    await UserIdService.deleteUserId();
    await resetDI();
  }
}

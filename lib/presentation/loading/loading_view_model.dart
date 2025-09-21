import 'package:flutter/material.dart';
import 'package:memory_desk/data/repository/user_repository.dart';
import 'package:memory_desk/data/services/remote_service.dart';
import 'package:memory_desk/data/services/user_id_service.dart';
import 'package:memory_desk/domain/entities/user_entity.dart';
import 'package:memory_desk/service_locator.dart';

class LoadingViewModel extends ChangeNotifier {
  UserRepository _userRepository = getIt.get<UserRepository>();

  Future<bool> loadUser() async {
    String? userId = await UserIdService.getUserId();

    if (userId == null) {
      return false;
    }
    final response = await RemoteService.getUserById(userId);

    final user = response.data;

    if (user == null) {
      return false;
    }
    _userRepository.updateLocalUserData(UserEntity.fromApi(user));
    return true;
  }
}

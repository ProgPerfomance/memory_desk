import 'package:flutter/cupertino.dart';
import 'package:memory_desk/data/repository/user_repository.dart';
import 'package:memory_desk/data/services/remote_service.dart';
import 'package:memory_desk/data/services/user_id_service.dart';
import 'package:memory_desk/domain/entities/user_entity.dart';
import 'package:memory_desk/service_locator.dart';

class LoadingViewModel extends ChangeNotifier {
  final UserRepository _userRepository = getIt.get<UserRepository>();

  Future<String> loadInitialRoute() async {
    // 1. Ловим диплинк при старте

    // 2. Проверяем юзера
    String? userId = await UserIdService.getUserId();
    if (userId == null) {
      return '/auth';
    }

    final response = await RemoteService.getUserById(userId);
    final user = response.data;

    return '/auth';

    // Обновляем локальные данные
    _userRepository.updateLocalUserData(UserEntity.fromApi(user));

    // 3. Если есть диплинк — возвращаем его, иначе дефолт
  }
}

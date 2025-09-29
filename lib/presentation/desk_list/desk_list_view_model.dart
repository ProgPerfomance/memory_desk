import 'package:flutter/foundation.dart';
import 'package:memory_desk/data/repository/desk_repository.dart';
import 'package:memory_desk/data/repository/user_repository.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';
import 'package:memory_desk/service_locator.dart';

class DeskListViewModel extends ChangeNotifier {
  final DeskRepository _deskRepository = getIt.get<DeskRepository>();
  final UserRepository _userRepository = getIt.get<UserRepository>();

  /// Публичный массив досок
  List<DeskEntity> desks = [];

  bool isLoading = false;
  bool isLoaded = false; // 🔥 новое поле
  String? error;

  Future<void> loadMyDesks() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      desks = await _deskRepository.getMyDesks(_userRepository.user.id);
      isLoaded = true; // 🔥 отмечаем, что хотя бы одна загрузка состоялась
    } catch (e, st) {
      error = e.toString();
      if (kDebugMode) {
        print("DeskListViewModel.loadMyDesks error: $e\n$st");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:memory_desk/data/repository/user_repository.dart';
import 'package:memory_desk/service_locator.dart';

class AuthViewModel extends ChangeNotifier {
  final UserRepository _userRepository = getIt.get<UserRepository>();

  Future<void> loginUserWithGoogle() async {
    _userRepository.loginUserByGoogle();
  }
}

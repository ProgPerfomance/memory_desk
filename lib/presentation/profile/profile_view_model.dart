import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_desk/data/repository/user_repository.dart';
import 'package:memory_desk/domain/entities/user_entity.dart';
import 'package:memory_desk/service_locator.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository _userRepository = getIt.get<UserRepository>();

  Future<void> logout() async {
    await _userRepository.logout();
  }

  UserEntity get user => _userRepository.user;
}

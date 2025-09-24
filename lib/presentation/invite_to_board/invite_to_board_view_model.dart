import 'package:flutter/material.dart';
import 'package:memory_desk/data/repository/desk_invites_repository.dart';
import 'package:memory_desk/data/repository/user_repository.dart';
import 'package:memory_desk/domain/entities/user_entity.dart';
import 'package:memory_desk/service_locator.dart';

class InviteToBoardViewModel extends ChangeNotifier {
  final UserRepository _userRepository = getIt.get<UserRepository>();
  final DeskInvitesRepository _deskInvitesRepository =
      getIt.get<DeskInvitesRepository>();
  List<UserEntity> users = [];
  Future<void> searchUsers(String query) async {
    users = await _userRepository.searchUsers(query);
    notifyListeners();
  }

  Future<void> inviteUserToDesk(String userId, String deskId) async {
    await _deskInvitesRepository.inviteUserToDesk(
      userId,
      deskId,
      _userRepository.user.id,
    );
  }
}

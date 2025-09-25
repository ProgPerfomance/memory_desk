import 'package:flutter/material.dart';
import 'package:memory_desk/data/repository/desk_invites_repository.dart';
import 'package:memory_desk/data/repository/user_repository.dart';
import 'package:memory_desk/domain/entities/invite_desk_entity.dart';
import 'package:memory_desk/service_locator.dart';

class MyInvitesViewModel extends ChangeNotifier {
  final DeskInvitesRepository _deskInvitesRepository =
      getIt.get<DeskInvitesRepository>();
  final UserRepository _userRepository = getIt.get<UserRepository>();

  bool isLoading = false;

  List<InviteDeskEntity> activeInvites = [];
  List<InviteDeskEntity> acceptedInvites = [];
  List<InviteDeskEntity> declinedInvites = [];

  Future<void> loadInvites() async {
    isLoading = true;
    notifyListeners();

    try {
      final List<InviteDeskEntity> response = await _deskInvitesRepository
          .getMyInvites(_userRepository.user.id);

      activeInvites = response.where((e) => e.status == "pending").toList();
      acceptedInvites = response.where((e) => e.status == "approved").toList();
      declinedInvites = response.where((e) => e.status == "declined").toList();
    } catch (e) {
      // TODO: логирование/обработка ошибки
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> declineInvite(String inviteId) async {
    try {
      await _deskInvitesRepository.declineInvite(inviteId);
      await loadInvites();
    } catch (e) {
      // TODO: обработка ошибки
    }
  }

  Future<void> acceptInvite(
    String inviteId,
    String recipientId,
    String deskId,
  ) async {
    try {
      await _deskInvitesRepository.approveInvite(inviteId, recipientId, deskId);
      await loadInvites();
    } catch (e) {
      // TODO: обработка ошибки
    }
  }
}

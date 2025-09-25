import 'package:memory_desk/data/services/remote_service.dart';
import 'package:memory_desk/domain/entities/invite_desk_entity.dart';

class DeskInvitesRepository {
  Future<void> inviteUserToDesk(
    String recipientId,
    String deskId,
    String senderId,
  ) async {
    final response = await RemoteService.sendInvite({
      "deskId": deskId,
      "senderId": senderId,
      "recipientId": recipientId,
    });
  }

  Future<List<InviteDeskEntity>> getMyInvites(String userId) async {
    final response = await RemoteService.getMyInvites(userId);

    List data = response.data;
    print(data);
    return data.map((v) => InviteDeskEntity.fromApi(v)).toList();
  }

  Future<void> approveInvite(
    String inviteId,
    String recipientId,
    String deskId,
  ) async {
    final response = await RemoteService.approveInvite(
      inviteId,
      recipientId,
      deskId,
    );
  }

  Future<void> declineInvite(String inviteId) async {
    final response = await RemoteService.declineInvite(inviteId);
  }
}

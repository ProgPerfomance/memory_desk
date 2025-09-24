import 'package:memory_desk/data/services/remote_service.dart';

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
}

// "deskId": data['deskId'],
//       "senderId": data['userId'],
//       "recipientId": data['recipientId'],

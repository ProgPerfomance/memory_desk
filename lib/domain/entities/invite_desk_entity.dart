import 'package:memory_desk/domain/entities/desk_entity.dart';
import 'package:memory_desk/domain/entities/user_entity.dart';

class InviteDeskEntity {
  final String id;
  final String deskId;
  final String senderId;
  final String recipientId;
  final DeskEntity? desk;
  final UserEntity? user;
  final String status;

  InviteDeskEntity({
    this.user,
    this.desk,
    required this.id,
    required this.deskId,
    required this.senderId,
    required this.recipientId,
    required this.status,
  });

  factory InviteDeskEntity.fromApi(Map map) {
    return InviteDeskEntity(
      id: map['_id'],
      deskId: map['deskId'],
      senderId: map['senderId'],
      recipientId: map['recipientId'],
      status: map['status'],
      desk: map['desk'] != null ? DeskEntity.fromApi(map['desk']) : null,
      user: map['user'] != null ? UserEntity.fromApi(map['user']) : null,
    );
  }
}

import 'package:memory_desk/data/services/remote_service.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';

class DeskRepository {
  Future<void> createDesk(DeskEntity desk) async {
    final response = await RemoteService.createDesk(desk.toApi());
  }
}

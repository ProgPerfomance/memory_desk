import 'package:memory_desk/data/services/remote_service.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';

class DeskRepository {
  Future<void> createDesk(DeskEntity desk) async {
    final response = await RemoteService.createDesk(desk.toApi());
  }

  Future<List<DeskEntity>> getMyDesks(String userId) async {
    final response = await RemoteService.getUserDesks(userId);
    List data = response.data;

    return data.map((v) => DeskEntity.fromApi(v)).toList();
  }
}

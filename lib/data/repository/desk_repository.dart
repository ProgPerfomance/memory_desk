import 'package:memory_desk/data/services/remote_service.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';
import 'package:memory_desk/domain/entities/desk_image_entity.dart';
import 'package:memory_desk/presentation/add_images/add_image_view_model.dart';
import 'package:memory_desk/presentation/gallery/gallery_view.dart';

class DeskRepository {
  Future<void> createDesk(DeskEntity desk) async {
    final response = await RemoteService.createDesk(desk.toApi());
  }

  Future<List<DeskEntity>> getMyDesks(String userId) async {
    final response = await RemoteService.getUserDesks(userId);
    List data = response.data;

    return data.map((v) => DeskEntity.fromApi(v)).toList().reversed.toList();
  }

  Future<void> uploadImagesToDesk(
    List<UploadPhoto> images,
    String deskId,
  ) async {
    final response = await RemoteService.uploadDeskImages({
      "images":
          images
              .map(
                (v) => {
                  "imageUrl": v.uploadedUrl ?? "",
                  "caption": v.caption,
                  "deskId": deskId,
                  "rotation": randomAngle(),
                },
              )
              .toList(),
    });
  }

  Future<List<DeskImageEntity>> getDeskImages(String deskId) async {
    final response = await RemoteService.loadImagesOnDesk(deskId);
    List data = response.data;
    return data
        .map((v) => DeskImageEntity.fromApi(v))
        .toList()
        .reversed
        .toList();
  }

  Future<void> updateImageRotation(String imageId, double rotation) async {
    final response = await RemoteService.updateImageRotation(imageId, rotation);
  }
}

// gallery_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:memory_desk/data/repository/desk_repository.dart';
import 'package:memory_desk/domain/entities/desk_image_entity.dart';
import 'package:memory_desk/service_locator.dart';

class GalleryViewModel extends ChangeNotifier {
  final DeskRepository _deskRepository = getIt.get<DeskRepository>();

  List<DeskImageEntity> deskPhotos = [];
  bool isLoading = false;
  String? error;

  Future<void> load(String deskId) async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      deskPhotos = await _deskRepository.getDeskImages(deskId);
    } catch (e, st) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('GalleryViewModel.load error: $e\n$st');
      }
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh(String deskId) async {
    // принудительно
    error = null;
    await load(deskId);
  }

  Future<void> updateImageRotation(String imageId, double rotation) async {
    try {
      await _deskRepository.updateImageRotation(imageId, rotation);

      // локально обновляем
      final index = deskPhotos.indexWhere((e) => e.id == imageId);
      if (index != -1) {
        deskPhotos[index] = deskPhotos[index].copyWith(rotation: rotation);
      }

      notifyListeners();
    } catch (e, st) {
      if (kDebugMode) {
        print('updateImageRotation error: $e\n$st');
      }
      error = e.toString();
      notifyListeners();
    }
  }
}

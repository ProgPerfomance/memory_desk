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
}

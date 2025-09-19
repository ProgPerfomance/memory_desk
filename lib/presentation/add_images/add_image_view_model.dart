// add_image_view_model.dart (VM)

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:memory_desk/data/repository/desk_repository.dart';
import 'package:memory_desk/service_locator.dart';

enum UploadStatus { pending, uploading, success, error }

class UploadPhoto {
  final Uint8List bytes;
  final String
  imageType; // jpg/png/webp — берём из расширения, по умолчанию jpg
  String caption;
  UploadStatus status;
  String? uploadedUrl;

  UploadPhoto({
    required this.bytes,
    required this.imageType,
    this.caption = "",
    this.status = UploadStatus.pending,
    this.uploadedUrl,
  });
}

class UploadPhotosViewModel extends ChangeNotifier {
  final DeskRepository _deskRepository = getIt.get<DeskRepository>();

  final ImagePicker _picker = ImagePicker();

  List<UploadPhoto> photos = [];
  Set<int> selectedIndexes = {};
  bool isUploading = false;

  /// Пакетная загрузка всех фоток последовательно.
  /// После выполнения готовый payload доступен через [uploadedPayload].
  Future<void> uploadAll(String deskId) async {
    if (isUploading || photos.isEmpty) return;
    isUploading = true;
    notifyListeners();

    for (int i = 0; i < photos.length; i++) {
      final p = photos[i];
      if (p.status == UploadStatus.success) continue;

      // отмечаем как uploading
      photos[i] = UploadPhoto(
        bytes: p.bytes,
        imageType: p.imageType,
        caption: p.caption,
        status: UploadStatus.uploading,
        uploadedUrl: p.uploadedUrl,
      );
      notifyListeners();

      try {
        final b64 = base64Encode(p.bytes);
        final resp = await http.post(
          Uri.parse('http://localhost:3322/photos/add'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'imageType': p.imageType, // ожидается на бэке
            'imageString': b64,
          }),
        );
        print(resp.body);

        if (resp.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(resp.body);
          final url =
              data['image']
                  as String?; // контроллер возвращает {'image': uploadedUrl}
          if (url == null || url.isEmpty) throw Exception('Пустой url');
          photos[i] = UploadPhoto(
            bytes: p.bytes,
            imageType: p.imageType,
            caption: p.caption,
            status: UploadStatus.success,
            uploadedUrl: url,
          );
        } else {
          throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
        }
      } catch (e) {
        photos[i] = UploadPhoto(
          bytes: p.bytes,
          imageType: p.imageType,
          caption: p.caption,
          status: UploadStatus.error,
          uploadedUrl: p.uploadedUrl,
        );
      }
      notifyListeners();
    }

    isUploading = false;
    _deskRepository.uploadImagesToDesk(photos, deskId);
    notifyListeners();
  }

  /// Готовый массив для следующего шага:
  /// [{ "imageUrl": "...", "caption": "..." }, ...]
  List<Map<String, String>> get uploadedPayload {
    return photos
        .where((p) => p.status == UploadStatus.success && p.uploadedUrl != null)
        .map((p) => {'imageUrl': p.uploadedUrl!, 'caption': p.caption})
        .toList();
  }

  Future<void> pickImages() async {
    try {
      final pickedFiles = await _picker.pickMultiImage(imageQuality: 85);
      if (pickedFiles.isNotEmpty) {
        final futures = pickedFiles.map((f) async {
          final bytes = await f.readAsBytes();
          final ext = _extFromName(f.name);
          return UploadPhoto(bytes: bytes, imageType: ext);
        });
        final items = await Future.wait(futures);
        photos.addAll(items);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print("pickImages error: $e");
    }
  }

  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
    notifyListeners();
  }

  void updateCaption(int index, String value) {
    if (index < 0 || index >= photos.length) return;
    final p = photos[index];
    photos[index] = UploadPhoto(
      bytes: p.bytes,
      imageType: p.imageType,
      caption: value,
      status: p.status,
      uploadedUrl: p.uploadedUrl,
    );
    notifyListeners();
  }

  void removeSelected() {
    photos = [
      for (var i = 0; i < photos.length; i++)
        if (!selectedIndexes.contains(i)) photos[i],
    ];
    selectedIndexes.clear();
    notifyListeners();
  }

  void clearAll() {
    photos.clear();
    selectedIndexes.clear();
    notifyListeners();
  }

  String _extFromName(String name) {
    final dot = name.lastIndexOf('.');
    if (dot == -1 || dot == name.length - 1) return 'jpg';
    final ext = name.substring(dot + 1).toLowerCase();
    // ограничим набор, остальное в jpg
    if (ext == 'jpg' || ext == 'jpeg') return 'jpg';
    if (ext == 'png') return 'png';
    if (ext == 'webp') return 'webp';
    return 'jpg';
  }
}

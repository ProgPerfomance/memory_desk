import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_desk/data/repository/desk_repository.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';
import 'package:memory_desk/service_locator.dart';

class CreateDeskViewModel extends ChangeNotifier {
  final DeskRepository _deskRepository = getIt.get<DeskRepository>();

  final List<String> backgrounds = [
    "https://cdn1.ozonusercontent.com/s3/club-storage/images/article_image_752x940/1016/c500/01ba2fbd-cb08-402e-be06-59e5dd4b0608.jpeg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR72n9kG3NfDd_WUbXeutHpaTpfiwsvX5SVCg&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOWOS28EvkLSzqOjG0i-AQmGWIkxFiXHVPEg&s",
    "https://img.freepik.com/free-photo/home-still-life-with-burning-candles-as-home-decor-details_169016-11265.jpg?semt=ais_hybrid&w=740&q=80",
    "https://i.pinimg.com/736x/55/06/2c/55062c56e781b2a84c89c07e95292a07.jpg",
  ];

  PrivacyTypes privacyType = PrivacyTypes.private;

  void selectPrivacyType(PrivacyTypes type) {
    privacyType = type;
    notifyListeners();
  }

  final _picker = ImagePicker();

  File? userImage; // если выбрано своё фото
  String? selectedImageUrl; // если выбран пресет

  CreateDeskViewModel() {
    // дефолтно — первая из backgrounds
    selectedImageUrl = backgrounds.first;
  }

  /// Текущий ImageProvider для фона
  ImageProvider get currentBackground {
    if (userImage != null) return FileImage(userImage!);
    return NetworkImage(selectedImageUrl ?? backgrounds.first);
  }

  /// CTA: выбрать своё изображение из галереи (single)
  Future<void> pickUserImage() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (x == null) return;
    userImage = File(x.path);
    selectedImageUrl = null; // сбрасываем пресет
    notifyListeners();
  }

  /// Выбор из предложенных фонов (сбросить пользовательский)
  void selectImage(String url) {
    selectedImageUrl = url;
    userImage = null;
    notifyListeners();
  }

  /// Показать превью CTA вместо плюса, если уже загружено своё
  ImageProvider? get userThumb =>
      userImage != null ? FileImage(userImage!) : null;

  Future<void> createDesk(String name, String description) async {
    await _deskRepository.createDesk(
      DeskEntity(
        privacy: privacyType.name,
        id: null,
        name: name,
        userId: "333",
        description: description,
        backgroundUrl: selectedImageUrl ?? "",
      ),
    );
  }
}

enum PrivacyTypes { private, link, public }

// gallery_view.dart
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';
import 'package:memory_desk/presentation/desk_list/desk_list_view.dart';
import 'package:memory_desk/presentation/edit_desk/edit_desk_view.dart';
import 'package:memory_desk/presentation/gallery/widgets/action_button.dart';
import 'package:memory_desk/presentation/gallery/widgets/photo_card.dart';
import 'package:provider/provider.dart';

import 'gallery_view_model.dart';
import '../add_images/add_images_view.dart';

class GalleryView extends StatelessWidget {
  final String deskId;
  final DeskEntity desk;
  const GalleryView({super.key, required this.deskId, required this.desk});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GalleryViewModel()..load(deskId),
      child: _GalleryScreen(deskId: deskId, desk: desk),
    );
  }
}

class _GalleryScreen extends StatelessWidget {
  final String deskId;
  final DeskEntity desk;
  const _GalleryScreen({required this.deskId, required this.desk});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GalleryViewModel>();

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(desk.backgroundUrl),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              if (vm.isLoading && vm.deskPhotos.isEmpty)
                const Center(child: CircularProgressIndicator()),

              if (!vm.isLoading && vm.error != null)
                ListView(
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Ошибка загрузки: ${vm.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),

              if (!vm.isLoading && vm.error == null && vm.deskPhotos.isEmpty)
                ListView(
                  children: const [
                    SizedBox(height: 120),
                    Center(
                      child: Text(
                        'Пока нет фотографий',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),

              if (vm.deskPhotos.isNotEmpty)
                MasonryGridView.count(
                  padding: const EdgeInsets.only(
                    left: 14,
                    right: 14,
                    top: 100,
                    bottom: 20,
                  ),
                  physics:
                      const BouncingScrollPhysics(), // либо ClampingScrollPhysics()
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 8,
                  itemCount: vm.deskPhotos.length,
                  itemBuilder: (context, index) {
                    final img = vm.deskPhotos[index];
                    return PhotoCard(
                      rotation: img.rotation,
                      imageUrl: img.imageUrl,
                      caption: img.caption,
                      index: index,
                      allUrls: vm.deskPhotos,
                    );
                  },
                ),

              /// Кнопки справа внизу
              Positioned(
                bottom: 20,
                right: 20,
                left: 20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Row(
                    children: [
                      TitleAndDescription(
                        title: desk.name,
                        description: desk.description,
                      ),
                      Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ActionButton(
                            icon: Icons.add,
                            onTap: () async {
                              // Переходим на экран добавления и ждём результат,
                              // затем перезагружаем галерею
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => UploadPhotosView(deskId: deskId),
                                ),
                              );
                              await context.read<GalleryViewModel>().refresh(
                                deskId,
                              );
                            },
                          ),
                          const SizedBox(height: 14),
                          ActionButton(
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditDeskView(desk: desk),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 80,
                left: 8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(188),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double randomAngle() {
  final random = Random();
  final degrees = -8 + random.nextInt(17);
  return degrees * pi / 180;
}

// gallery_view.dart
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';
import 'package:provider/provider.dart';

import 'gallery_view_model.dart';
import '../add_images/add_images_view.dart';
import '../open_image/open_image_view.dart'; // твой просмотрщик

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
                  // чтобы тянулось для refresh
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
                      imageUrl: img.imageUrl,
                      caption: img.caption,
                      index: index,
                      allUrls: vm.deskPhotos.map((e) => e.imageUrl).toList(),
                    );
                  },
                ),

              /// Кнопки справа внизу
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
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
                            builder: (_) => UploadPhotosView(deskId: deskId),
                          ),
                        );
                        await context.read<GalleryViewModel>().refresh(deskId);
                      },
                    ),
                    const SizedBox(height: 14),
                    ActionButton(
                      icon: Icons.edit,
                      onTap: () {
                        // TODO: редактировать доску
                      },
                    ),
                  ],
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

class ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ActionButton({required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.black87,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  final String imageUrl;
  final String? caption;
  final int index;
  final List<String> allUrls;

  const PhotoCard({
    super.key,
    required this.imageUrl,
    required this.index,
    required this.allUrls,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _randomAngle(),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhotoViewer(photos: allUrls, initialIndex: index),
            ),
          );
        },
        child: Hero(
          tag: imageUrl,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                if (caption != null && caption!.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.45),
                          ],
                        ),
                      ),
                      child: Text(
                        caption!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(color: Colors.black38, blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: -8,
                  right: -8,
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Image.asset(
                      "assets/images/pinned.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double _randomAngle() {
  final random = Random();
  final degrees = -8 + random.nextInt(17);
  return degrees * pi / 180;
}

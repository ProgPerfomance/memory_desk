import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../open_image/open_image_view.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            /// Сетка фоток
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 18,
                  children: List.generate(images.length, (index) {
                    final v = images[index];
                    return StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: PhotoCard(
                        imageUrl: v,
                        caption: "Пример подписи",
                        index: index,
                      ),
                    );
                  }),
                ),
              ),
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
                    onTap: () {
                      // TODO: добавить фотку
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
          ],
        ),
      ),
    );
  }
}

/// Кастомная круглая кнопка
class ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ActionButton({required this.icon, required this.onTap});

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

  const PhotoCard({
    super.key,
    required this.imageUrl,
    this.caption,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: randomAngle(),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PhotoViewer(photos: images, initialIndex: index),
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
                // 👉 ключевой момент — Image сам тянет высоту по ratio
                Image.network(imageUrl, fit: BoxFit.cover),

                // Подпись
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

                // Иконка в углу
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

List<String> images = [
  "https://i.pinimg.com/236x/c8/cc/24/c8cc24bba37a25c009647b8875aae0e3.jpg",
  "https://cs14.pikabu.ru/post_img/big/2023/04/20/3/1681956381171584576.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxlFCXTU1vPdkR0G7B_Ur8VRWUSg73w8cT9A&s",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-RD5GYGuVntEQ_QS8sMrjb7OVxJRWRAqkZw&s",
];

// class ImageCardDTO {
//   final String imageUrl;
//   final String? title;
// }

double randomAngle() {
  final random = Random();
  final degrees = -8 + random.nextInt(17); // от -8 до 8 включительно
  return degrees * pi / 180; // переводим в радианы
}

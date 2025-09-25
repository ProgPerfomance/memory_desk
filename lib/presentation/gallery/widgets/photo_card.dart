import 'package:flutter/material.dart';
import 'package:memory_desk/domain/entities/desk_image_entity.dart';
import 'package:provider/provider.dart';

import '../../open_image/open_image_view.dart';
import '../gallery_view.dart';
import '../gallery_view_model.dart';

class PhotoCard extends StatelessWidget {
  final String imageUrl;
  final String? caption;
  final int index;
  final List<DeskImageEntity> allUrls;
  final double? rotation;
  final DeskImageEntity image;

  const PhotoCard({
    super.key,
    required this.imageUrl,
    required this.index,
    required this.allUrls,
    this.caption,
    required this.rotation,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation ?? 0,
      child: GestureDetector(
        onLongPress: () {
          showRotateOverlay(context, image, (newRotation) {
            context.read<GalleryViewModel>().updateImageRotation(
              image.id!,
              newRotation,
            );
          });
        },
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
                ClipRRect(
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12),
                ),
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

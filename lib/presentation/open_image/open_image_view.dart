import 'package:flutter/material.dart';
import 'package:memory_desk/domain/entities/desk_image_entity.dart';

class PhotoViewer extends StatefulWidget {
  final List<DeskImageEntity> photos;
  final int initialIndex;

  const PhotoViewer({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! > 0 ||
                    details.primaryVelocity! < 0) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.photos.length,
              itemBuilder: (context, index) {
                final photo = widget.photos[index];
                return Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: photo.imageUrl,
                        child: InteractiveViewer(
                          child: Image.network(
                            photo.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // Подпись (caption) внизу слева
                    Positioned(
                      left: 16,
                      bottom: 32,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          photo.caption ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Кнопка назад
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

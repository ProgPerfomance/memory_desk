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

class _PhotoViewerState extends State<PhotoViewer>
    with SingleTickerProviderStateMixin {
  late PageController _controller;
  bool _menuOpen = false;
  late AnimationController _menuController;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fade = CurvedAnimation(parent: _menuController, curve: Curves.easeInOut);
  }

  void _toggleMenu() {
    if (_menuOpen) {
      _menuController.reverse();
    } else {
      _menuController.forward();
    }
    setState(() => _menuOpen = !_menuOpen);
  }

  @override
  void dispose() {
    _menuController.dispose();
    _controller.dispose();
    super.dispose();
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

                    // Подпись (caption)
                    if ((photo.caption ?? '').isNotEmpty)
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

          // Кнопка "Редактировать"
          Positioned(
            bottom: 32,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizeTransition(
                  sizeFactor: _fade,
                  axisAlignment: -1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _MenuButton(
                        icon: Icons.auto_fix_high,
                        label: "Фото-редактор",
                        onTap: () {
                          // TODO: открыть фото-редактор
                          _toggleMenu();
                        },
                      ),
                      const SizedBox(height: 8),
                      _MenuButton(
                        icon: Icons.crop_square,
                        label: "Изменить рамку",
                        onTap: () {
                          // TODO: изменить рамку
                          _toggleMenu();
                        },
                      ),
                      const SizedBox(height: 8),
                      _MenuButton(
                        icon: Icons.delete,
                        label: "Удалить фото",
                        onTap: () {
                          // TODO: удалить фото
                          _toggleMenu();
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // Внутри Positioned вместо FloatingActionButton:
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: GestureDetector(
                    onTap: _toggleMenu,
                    child: AnimatedRotation(
                      turns:
                          _menuOpen ? 0.25 : 0.0, // лёгкий поворот при открытии
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons
                            .auto_fix_high, // ✨ или можно Icons.more_vert для более нейтрального стиля
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.6),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

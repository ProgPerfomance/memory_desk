// gallery_view.dart
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';
import 'package:memory_desk/presentation/desk_list/desk_list_view.dart';
import 'package:memory_desk/presentation/edit_desk/edit_desk_view.dart';
import 'package:memory_desk/presentation/gallery/widgets/action_button.dart';
import 'package:memory_desk/presentation/gallery/widgets/photo_card.dart';
import 'package:memory_desk/presentation/gallery_peoples/gallery_peoples_view.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/desk_image_entity.dart';
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
                      image: img,
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
                          SizedBox(height: 14),
                          ActionButton(
                            icon: Icons.people,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          GalleryPeoplesView(deskId: deskId),
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

void showRotateOverlay(
  BuildContext context,
  DeskImageEntity img,
  Function(double) onSave,
) {
  double tempRotation = img.rotation ?? 0;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.4),
    pageBuilder: (context, anim1, anim2) {
      return _RotateOverlayContent(
        imageUrl: img.imageUrl,
        initialRotation: tempRotation,
        onSave: onSave,
      );
    },
  );
}

class _RotateOverlayContent extends StatefulWidget {
  final String imageUrl;
  final double initialRotation;
  final Function(double) onSave;

  const _RotateOverlayContent({
    required this.imageUrl,
    required this.initialRotation,
    required this.onSave,
  });

  @override
  State<_RotateOverlayContent> createState() => _RotateOverlayContentState();
}

class _RotateOverlayContentState extends State<_RotateOverlayContent>
    with TickerProviderStateMixin {
  late double tempRotation;
  late AnimationController _hintController;
  late AnimationController _iconController;
  late Animation<double> _hintAnimation;

  @override
  void initState() {
    super.initState();
    tempRotation = widget.initialRotation;

    // контроллер "качания"
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _hintAnimation = Tween<double>(begin: -0.15, end: 0.15).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );

    // контроллер появления иконки 🔄
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // запускаем "качание" + иконку при старте
    Future.delayed(const Duration(milliseconds: 200), () async {
      await _iconController.forward();
      _hintController.forward().then((_) => _hintController.reverse());
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) await _iconController.reverse();
    });
  }

  @override
  void dispose() {
    _hintController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // блюр задника
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          // фото по центру с gesture
          Center(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  tempRotation += details.delta.dx * 0.01;
                });
              },
              child: AnimatedBuilder(
                animation: _hintController,
                builder: (context, child) {
                  final hintAngle =
                      _hintController.isAnimating ? _hintAnimation.value : 0.0;
                  return Transform.rotate(
                    angle: tempRotation + hintAngle,
                    child: child,
                  );
                },
                child: Image.network(widget.imageUrl, width: 280),
              ),
            ),
          ),

          // 🔄 иконка-подсказка
          Center(
            child: FadeTransition(
              opacity: _iconController,
              child: const Icon(
                Icons.rotate_right,
                size: 64,
                color: Colors.white70,
              ),
            ),
          ),

          // панель управления
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () {
                      widget.onSave(tempRotation);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

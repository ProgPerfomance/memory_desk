// add_image_view.dart (View)

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'add_image_open_view.dart';
import 'add_image_view_model.dart';

class UploadPhotosView extends StatelessWidget {
  final String deskId;
  const UploadPhotosView({super.key, required this.deskId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadPhotosViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          "Загрузка фото",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          if (vm.selectedIndexes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: vm.removeSelected,
              tooltip: 'Удалить выбранные',
            ),
        ],
      ),
      backgroundColor: const Color(0xFFFAF5ED),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (vm.photos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton.icon(
                onPressed:
                    vm.isUploading
                        ? null
                        : () async {
                          await context.read<UploadPhotosViewModel>().uploadAll(
                            deskId,
                          );
                          final payload =
                              context
                                  .read<UploadPhotosViewModel>()
                                  .uploadedPayload;
                          if (payload.isNotEmpty) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Не удалось загрузить фото'),
                              ),
                            );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                icon:
                    vm.isUploading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.cloud_upload, size: 22),
                label: const Text(
                  "Загрузить",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          FloatingActionButton(
            onPressed: vm.isUploading ? null : () => vm.pickImages(),
            backgroundColor: Colors.black,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),

      body:
          vm.photos.isEmpty
              ? const Center(
                child: Text(
                  "Нет фото. Нажмите + чтобы выбрать.",
                  style: TextStyle(color: Colors.black54),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(12),
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: List.generate(vm.photos.length, (index) {
                    final p = vm.photos[index];
                    final selected = vm.selectedIndexes.contains(index);

                    return StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PhotoDetailView(index: index),
                            ),
                          );
                        },
                        onLongPress: () => vm.toggleSelection(index),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.memory(
                                p.bytes,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),

                            // подпись (если есть)
                            if (p.caption.isNotEmpty)
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(14),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.6),
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    p.caption,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                            // статус загрузки
                            if (p.status == UploadStatus.uploading)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.black38,
                                  ),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (p.status == UploadStatus.success)
                              const Positioned(
                                right: 8,
                                top: 8,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.greenAccent,
                                  size: 22,
                                ),
                              ),
                            if (p.status == UploadStatus.error)
                              const Positioned(
                                right: 8,
                                top: 8,
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: 22,
                                ),
                              ),

                            // выделение
                            if (selected)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  color: Colors.black26,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_image_view_model.dart';

class PhotoDetailView extends StatefulWidget {
  final int index;
  const PhotoDetailView({super.key, required this.index});

  @override
  State<PhotoDetailView> createState() => _PhotoDetailViewState();
}

class _PhotoDetailViewState extends State<PhotoDetailView> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final vm = context.read<UploadPhotosViewModel>();
    _controller = TextEditingController(text: vm.photos[widget.index].caption);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadPhotosViewModel>();
    final photo = vm.photos[widget.index];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.memory(photo.bytes, fit: BoxFit.contain),
              ),
            ),
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                controller: _controller,
                onChanged: (v) => vm.updateCaption(widget.index, v.trim()),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: "Добавьте подпись...",
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

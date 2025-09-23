import 'package:flutter/material.dart';

class FrameEditorView extends StatefulWidget {
  final String imageUrl;

  const FrameEditorView({super.key, required this.imageUrl});

  @override
  State<FrameEditorView> createState() => _FrameEditorViewState();
}

class _FrameEditorViewState extends State<FrameEditorView> {
  bool showFrame = true;
  Color frameColor = Colors.white;
  double frameWidth = 4;
  double borderRadius = 0;

  double? aspectRatio;

  @override
  void initState() {
    super.initState();
    _loadAspectRatio();
  }

  void _loadAspectRatio() {
    final img = Image.network(widget.imageUrl);
    img.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            final ratio = info.image.width / info.image.height;
            if (mounted) {
              setState(() => aspectRatio = ratio);
            }
          }),
        );
  }

  final List<Color> colors = [
    Colors.black,
    Colors.white,
    Colors.grey,
    Colors.brown,
    const Color(0xFFFAF5ED), // беж из гайдлайна
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Редактор рамки",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: сохранить
              Navigator.of(context).pop();
            },
            child: const Text(
              "Готово",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Фото с адаптивностью
          Expanded(
            child: Center(
              child:
                  aspectRatio == null
                      ? const CircularProgressIndicator()
                      : Container(
                        decoration: BoxDecoration(
                          border:
                              showFrame
                                  ? Border.all(
                                    color: frameColor,
                                    width: frameWidth,
                                  )
                                  : null,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadius),
                          child: AspectRatio(
                            aspectRatio: aspectRatio!,
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
            ),
          ),

          // Панель
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      "Показать рамку",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: showFrame,
                      activeColor: Colors.black,
                      onChanged: (v) => setState(() => showFrame = v),
                    ),
                  ],
                ),
                const Divider(height: 32),

                const Text(
                  "Цвет рамки",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      colors
                          .map(
                            (c) => _ColorCircle(
                              c,
                              selected: frameColor == c,
                              onTap: () => setState(() => frameColor = c),
                            ),
                          )
                          .toList(),
                ),
                const Divider(height: 32),

                const Text(
                  "Толщина рамки",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Slider(
                  value: frameWidth,
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: frameWidth.toInt().toString(),
                  activeColor: Colors.black,
                  onChanged: (v) => setState(() => frameWidth = v),
                ),
                const Divider(height: 32),

                const Text(
                  "Скругление углов",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Slider(
                  value: borderRadius,
                  min: 0,
                  max: 40,
                  divisions: 8,
                  label: borderRadius.toInt().toString(),
                  activeColor: Colors.black,
                  onChanged: (v) => setState(() => borderRadius = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorCircle(this.color, {required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
            width: 2,
          ),
        ),
      ),
    );
  }
}

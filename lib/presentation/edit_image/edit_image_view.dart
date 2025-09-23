// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'edit_image_view_model.dart';
//
// class PhotoEditorView extends StatefulWidget {
//   final String imageUrl;
//
//   const PhotoEditorView({super.key, required this.imageUrl});
//
//   @override
//   State<PhotoEditorView> createState() => _PhotoEditorViewState();
// }
//
// class _PhotoEditorViewState extends State<PhotoEditorView> {
//   int _selectedTool = 0;
//
//   final List<_ToolItem> _tools = [
//     _ToolItem(Icons.crop, "Обрезка"),
//     _ToolItem(Icons.rotate_90_degrees_ccw, "Поворот"),
//     _ToolItem(Icons.filter, "Фильтры"),
//     _ToolItem(Icons.tune, "Правка"),
//     _ToolItem(Icons.text_fields, "Текст"),
//     _ToolItem(Icons.emoji_emotions, "Стикеры"),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF5ED),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Редактор",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         actions: [
//           TextButton(
//             onPressed: () {
//               // TODO: сохранить изменения
//               Navigator.pop(context);
//             },
//             child: const Text(
//               "Сохранить",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Фото-превью
//           Expanded(
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: 3 / 4,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Image.network(widget.imageUrl, fit: BoxFit.cover),
//                 ),
//               ),
//             ),
//           ),
//
//           // Панель инструментов
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8,
//                   offset: Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Иконки инструментов
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: List.generate(_tools.length, (index) {
//                     final tool = _tools[index];
//                     final selected = _selectedTool == index;
//                     return GestureDetector(
//                       onTap: () => setState(() => _selectedTool = index),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             tool.icon,
//                             size: 28,
//                             color: selected ? Colors.black : Colors.grey,
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             tool.label,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: selected ? Colors.black : Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // Динамическая панель под инструмент
//                 _buildToolPanel(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToolPanel() {
//     switch (_selectedTool) {
//       case 0: // Crop
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _CropButton("Свободно", 0),
//             _CropButton("1:1", 1),
//             _CropButton("4:3", 4 / 3),
//             _CropButton("16:9", 16 / 9),
//           ],
//         );
//       case 1: // Rotate
//         return const Text("Кнопки поворота / флипа появятся здесь");
//       case 2: // Filters
//         return const Text("Фильтры будут тут превьюшками");
//       case 3: // Adjust
//         return const Text("Слайдеры яркости/контраста/сатурации");
//       case 4: // Text
//         return const Text("Добавление текста");
//       case 5: // Stickers
//         return const Text("Выбор стикеров");
//       default:
//         return const SizedBox.shrink();
//     }
//   }
// }
//
// class _CropButton extends StatelessWidget {
//   final String label;
//   final double ratio;
//   const _CropButton(this.label, this.ratio);
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<PhotoEditorViewModel>();
//     final selected = vm.aspectRatio == ratio;
//
//     return GestureDetector(
//       onTap: () => vm.setAspectRatio(ratio),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: selected ? Colors.black : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? Colors.white : Colors.black,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _ToolItem {
//   final IconData icon;
//   final String label;
//   const _ToolItem(this.icon, this.label);
// }

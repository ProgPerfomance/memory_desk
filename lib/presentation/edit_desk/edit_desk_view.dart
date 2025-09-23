import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';

class EditDeskView extends StatefulWidget {
  final DeskEntity desk;
  const EditDeskView({super.key, required this.desk});

  @override
  State<EditDeskView> createState() => _EditDeskViewState();
}

class _EditDeskViewState extends State<EditDeskView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.desk.name);
    _descriptionController = TextEditingController(
      text: widget.desk.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED), // бежевый фон
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Редактирование доски",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Название
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Название доски",
                filled: true,
                fillColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Описание
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Описание доски",
                filled: true,
                fillColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.black54),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Кнопка сохранения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  // TODO: сохранить изменения
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                  });
                },
                child: const Text(
                  "Сохранить",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

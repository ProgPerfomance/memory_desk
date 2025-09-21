// edit_desk_view.dart
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Редактирование доски"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Название доски",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Описание доски",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

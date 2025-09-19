import 'package:flutter/material.dart';
import 'package:memory_desk/presentation/create_desk/step_2_view.dart';
import 'package:provider/provider.dart';
import 'create_desk_view_model.dart';

TextEditingController _nameController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();

class Step1View extends StatelessWidget {
  const Step1View({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateDeskViewModel>();
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Фон от VM (своё фото или выбранный пресет)
          Positioned.fill(
            child: Image(image: vm.currentBackground, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: "Название галереи...",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 22,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Описание
                  TextField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Короткое описание...",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                    ),
                    maxLines: 2,
                  ),

                  const Spacer(),

                  // Превью (горизонтально) + кнопка "продолжить"
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: screen.height * 0.25,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero, // справа в край
                          itemCount: 1 + vm.backgrounds.length, // CTA + пресеты
                          separatorBuilder:
                              (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, i) {
                            // 0 — CTA «загрузить своё»
                            if (i == 0) {
                              final thumb = vm.userThumb;
                              return GestureDetector(
                                onTap: vm.pickUserImage,
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // Фон — либо прозрачный, либо загруженное фото
                                        if (thumb == null)
                                          Container(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                          )
                                        else
                                          Image(
                                            image: thumb,
                                            fit: BoxFit.cover,
                                          ),

                                        // Если пользовательское фото — добавляем overlay и иконку
                                        if (thumb != null) ...[
                                          Container(
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                          const Center(
                                            child: Icon(
                                              Icons.edit,
                                              size: 32,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ] else
                                          const Center(
                                            child: Icon(
                                              Icons.add,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            // Пресеты
                            final url = vm.backgrounds[i - 1];
                            final isSelected =
                                vm.selectedImageUrl == url &&
                                vm.userImage == null;

                            return GestureDetector(
                              onTap: () => vm.selectImage(url),
                              child: AspectRatio(
                                aspectRatio: 9 / 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        isSelected
                                            ? Border.all(
                                              color: Colors.white,
                                              width: 3,
                                            )
                                            : null,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Кнопка "продолжить"
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Material(
                            shape: const CircleBorder(),
                            color: Colors.white,
                            elevation: 6,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => Step2PrivacyView(
                                          name: _nameController.text,
                                          description:
                                              _descriptionController.text,
                                        ),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

import 'package:flutter/material.dart';
import 'package:memory_desk/presentation/create_desk/create_desk_view_model.dart';
import 'package:provider/provider.dart';

class Step2PrivacyView extends StatelessWidget {
  final String name;
  final String description;
  const Step2PrivacyView({
    super.key,
    required this.description,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CreateDeskViewModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      body: SafeArea(
        child: Stack(
          children: [
            // Контент
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Приватность доски',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Выберите, кто сможет видеть и добавлять фото. Это всегда можно изменить позже.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Карточки-опции
                  _PrivacyCard(
                    type: PrivacyTypes.private,
                    title: 'Приватная',
                    subtitle: 'Видно только вам.',
                    icon: Icons.lock_outline,
                    selected: vm.privacyType == PrivacyTypes.private,
                  ),
                  const SizedBox(height: 12),
                  _PrivacyCard(
                    type: PrivacyTypes.link,
                    title: 'По ссылке',
                    subtitle: 'Доступ всем, у кого есть ссылка.',
                    icon: Icons.link,
                    selected: vm.privacyType == PrivacyTypes.link,
                  ),
                  const SizedBox(height: 12),
                  _PrivacyCard(
                    type: PrivacyTypes.public,
                    title: 'Публичная',
                    subtitle: 'Может найти и посмотреть любой пользователь.',
                    icon: Icons.public,
                    selected: vm.privacyType == PrivacyTypes.public,
                  ),
                ],
              ),
            ),

            // Нижняя панель
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Назад',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  const Spacer(),
                  Material(
                    shape: const CircleBorder(),
                    color: Colors.white,
                    elevation: 6,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () async {
                        await vm.createDesk(name, description);
                        Navigator.pop(context);
                        Navigator.pop(context);
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _PrivacyType { private, link, public }

class _PrivacyCard extends StatelessWidget {
  final PrivacyTypes type;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;

  const _PrivacyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.black : Colors.white;
    final fg = selected ? Colors.white : Colors.black87;
    final border = selected ? Colors.black : Colors.black12;
    final vm = Provider.of<CreateDeskViewModel>(context);
    return GestureDetector(
      onTap: () {
        vm.selectPrivacyType(type);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
          boxShadow:
              selected
                  ? const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ]
                  : const [],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color:
                    selected
                        ? Colors.white.withOpacity(0.14)
                        : const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: fg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: fg,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: selected ? Colors.white70 : Colors.black54,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: fg,
            ),
          ],
        ),
      ),
    );
  }
}

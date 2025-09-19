import 'package:flutter/material.dart';

/// Пред-MVP: чистый дизайн без логики и бэка.
/// Страница списка досок в светлой теме, full-width list view, 200px высота карточки.
class BoardsListView extends StatelessWidget {
  const BoardsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final boards = List.generate(
      6,
      (i) => Board(
        name: "Пума кот",
        description:
            "Пума реально кот. Красивые моменты и тёплые воспоминания. Здесь может быть длинное описание, показываем до 2 строк.",
        backgroundUrl:
            "https://cdn1.ozonusercontent.com/s3/club-storage/images/article_image_752x940/1016/c500/01ba2fbd-cb08-402e-be06-59e5dd4b0608.jpeg",
        privacy: i % 3 == 0 ? "private" : (i % 3 == 1 ? "link" : "public"),
        photoCount: 42 + i,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            const SizedBox(height: 12),
            const _MyAllSegmented(), // визуальный переключатель Мои/Все (без логики)
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: boards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder:
                    (context, index) => _BoardCard(board: boards[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Доски воспоминаний',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6),
          Text(
            'Просматривайте, показывайте и делитесь теплыми моментами. '
            'Настройки можно изменить в любой момент.',
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.3),
          ),
        ],
      ),
    );
  }
}

/// Псевдо-переключатель "Мои / Все" в духе Step2PrivacyView.
/// Чисто UI: активное состояние – «Мои».
class _MyAllSegmented extends StatelessWidget {
  const _MyAllSegmented();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            _SegmentButton(label: 'Мои', selected: true),
            const SizedBox(width: 6),
            _SegmentButton(label: 'Все', selected: false),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool selected;
  const _SegmentButton({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.black : Colors.transparent;
    final fg = selected ? Colors.white : Colors.black87;
    final border = selected ? Colors.black : Colors.transparent;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
          boxShadow:
              selected
                  ? const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ]
                  : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _BoardCard extends StatelessWidget {
  final Board board;
  const _BoardCard({required this.board});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.white,
        elevation: 0,
        child: InkWell(
          onTap: () {}, // чисто UI
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE6E6E6)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Фон-картинка
                Positioned.fill(child: _BoardImage(url: board.backgroundUrl)),
                // Мягкий градиент для читаемости
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.55),
                          Colors.black.withOpacity(0.20),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.35, 0.8],
                      ),
                    ),
                  ),
                ),
                // Бейдж приватности (левый верх)
                Positioned(
                  top: 12,
                  left: 12,
                  child: _PrivacyChip(privacy: board.privacy),
                ),
                // Кнопка меню (правый верх, визуально в стиле рефа)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: _RoundIcon(icon: Icons.more_vert),
                ),
                // Низ: заголовок, описание, счётчик фото
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _TitleAndDescription(
                          title: board.name,
                          description: board.description,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _PhotoCounter(count: board.photoCount),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardImage extends StatelessWidget {
  final String url;
  const _BoardImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: NetworkImage(url),
      fit: BoxFit.cover,
      child: const SizedBox.shrink(),
      // На случай битой ссылки — мягкая светлая заглушка:
      // Используем errorBuilder у Image.network, но Ink.image не имеет его.
      // Поэтому для строгости можно заменить на Image.network + InkWell, если потребуется.
    );
  }
}

class _TitleAndDescription extends StatelessWidget {
  final String title;
  final String description;
  const _TitleAndDescription({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.5,
            height: 1.32,
            color: Colors.white.withOpacity(0.94),
          ),
        ),
      ],
    );
  }
}

class _PhotoCounter extends StatelessWidget {
  final int count;
  const _PhotoCounter({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 16,
            color: Color(0xFF1F2937),
          ),
          const SizedBox(width: 6),
          Text(
            "$count",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyChip extends StatelessWidget {
  final String privacy; // "public" | "link" | "private"
  const _PrivacyChip({required this.privacy});

  @override
  Widget build(BuildContext context) {
    final data = _privacyStyle(privacy);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: data.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, size: 14, color: data.fg),
          const SizedBox(width: 6),
          Text(
            data.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: data.fg,
            ),
          ),
        ],
      ),
    );
  }
}

/// Круглая кнопка в стиле шага приватности (белая с чёрной иконкой).
class _RoundIcon extends StatelessWidget {
  final IconData icon;
  const _RoundIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.white,
      elevation: 6,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.black),
        ),
      ),
    );
  }
}

class Board {
  final String name;
  final String description;
  final String backgroundUrl;
  final String privacy;
  final int photoCount;

  Board({
    required this.name,
    required this.description,
    required this.backgroundUrl,
    required this.privacy,
    required this.photoCount,
  });
}

class _PrivacyStyle {
  final Color bg;
  final Color border;
  final Color fg;
  final String label;
  final IconData icon;
  const _PrivacyStyle(this.bg, this.border, this.fg, this.label, this.icon);
}

_PrivacyStyle _privacyStyle(String privacy) {
  switch (privacy) {
    case "public":
      return const _PrivacyStyle(
        Color(0xFFE8F5E9), // светло-зелёный
        Color(0xFFB7DEC0),
        Color(0xFF256C2E),
        "Публичная",
        Icons.public,
      );
    case "link":
      return const _PrivacyStyle(
        Color(0xFFE8F0FE), // светло-синий
        Color(0xFFBFDBFE),
        Color(0xFF1E40AF),
        "По ссылке",
        Icons.link,
      );
    default:
      return const _PrivacyStyle(
        Color(0xFFF3F4F6), // светло-серый
        Color(0xFFE5E7EB),
        Color(0xFF111827),
        "Приватная",
        Icons.lock_outline,
      );
  }
}

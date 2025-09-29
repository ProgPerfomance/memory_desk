import 'package:flutter/material.dart';
import 'package:memory_desk/core/ad_manager.dart';
import 'package:memory_desk/core/theme/colors.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';
import 'package:memory_desk/presentation/gallery/gallery_view.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'desk_list_view_model.dart';

import 'package:flutter/material.dart';
import 'package:memory_desk/core/ad_manager.dart';
import 'package:memory_desk/core/theme/colors.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';
import 'package:memory_desk/presentation/gallery/gallery_view.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'desk_list_view_model.dart';

class BoardsListView extends StatefulWidget {
  const BoardsListView({super.key});

  @override
  State<BoardsListView> createState() => _BoardsListViewState();
}

class _BoardsListViewState extends State<BoardsListView> {
  @override
  void initState() {
    super.initState();
    // грузим данные один раз при входе
    Future.microtask(() {
      final vm = context.read<DeskListViewModel>();
      if (!vm.isLoaded && !vm.isLoading) {
        vm.loadMyDesks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DeskListViewModel>();
    final boards = vm.desks;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  if (vm.isLoading) const LinearProgressIndicator(minHeight: 2),
                  const SizedBox(height: 16),
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.black,
                      onRefresh: () async {
                        await context.read<DeskListViewModel>().loadMyDesks();
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: boards.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index != boards.length) {
                            return _BoardCard(board: boards[index]);
                          } else {
                            return SizedBox(
                              height: 140,
                              child: AdWidget(
                                bannerAd: stickyAd(
                                  (MediaQuery.of(context).size.width - 32)
                                      .toInt(),
                                ),
                              ),
                            );
                          }
                        },
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

class _BoardCard extends StatelessWidget {
  final DeskEntity board;
  const _BoardCard({required this.board});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.white,
        elevation: 0,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        GalleryView(deskId: board.id ?? "", desk: board),
              ),
            );
          },
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE6E6E6)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned.fill(child: _BoardImage(url: board.backgroundUrl)),
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
                Positioned(
                  top: 12,
                  left: 12,
                  child: _PrivacyChip(privacy: board.privacy),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TitleAndDescription(
                          title: board.name,
                          description: board.description,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _PhotoCounter(count: board.imagesCount ?? 0),
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

class TitleAndDescription extends StatelessWidget {
  final String title;
  final String description;
  const TitleAndDescription({required this.title, required this.description});

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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory_desk/presentation/invite_to_board/invite_to_board_view.dart';

class GalleryPeoplesView extends StatelessWidget {
  const GalleryPeoplesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Моковые данные участников
    final friends = [
      FriendCardData(
        username: "@barsik",
        name: "Кот Барсик",
        avatarUrl: "https://i.pravatar.cc/150?img=1",
        isFavorite: true,
      ),
      FriendCardData(
        username: "@masha",
        name: "Маша",
        avatarUrl: "https://i.pravatar.cc/150?img=2",
      ),
      FriendCardData(
        username: "@petr",
        name: "Петя",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
      ),
    ];

    // Моковая ссылка на доску
    final boardLink = "https://thememories.app/board/123";

    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      appBar: AppBar(
        title: const Text(
          "Участники доски",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Список участников
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: friends.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (context, index) {
                final f = friends[index];
                return _FriendCard(friend: f);
              },
            ),
          ),

          // Ссылка на доску
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: boardLink));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ссылка скопирована")),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.link, color: Colors.black54),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          boardLink,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const Icon(Icons.copy, color: Colors.black54, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Кнопка пригласить
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => InviteToBoardView(boardLink: boardLink),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text(
                  "Пригласить",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FriendCardData {
  final String username;
  final String? name;
  final String avatarUrl;
  final bool isFavorite;

  FriendCardData({
    required this.username,
    this.name,
    required this.avatarUrl,
    this.isFavorite = false,
  });
}

class _FriendCard extends StatelessWidget {
  final FriendCardData friend;
  const _FriendCard({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(friend.avatarUrl),
            radius: 40,
          ),
          const SizedBox(height: 12),
          Text(
            friend.name ?? friend.username,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Text(
            friend.username,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          if (friend.isFavorite) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Любимый человек ❤️",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.pink,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

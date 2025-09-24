import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InviteToBoardView extends StatefulWidget {
  final String boardLink;
  const InviteToBoardView({super.key, required this.boardLink});

  @override
  State<InviteToBoardView> createState() => _InviteToBoardViewState();
}

class _InviteToBoardViewState extends State<InviteToBoardView> {
  final TextEditingController _controller = TextEditingController();

  // Моковые юзеры
  final List<UserData> allUsers = [
    UserData(
      username: "@barsik",
      name: "Кот Барсик",
      email: "barsik@example.com",
      avatarUrl: "https://i.pravatar.cc/150?img=1",
    ),
    UserData(
      username: "@masha",
      name: "Маша Иванова",
      email: "masha@mail.com",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
    ),
    UserData(
      username: "@petr",
      name: "Пётр Петров",
      email: "petr@gmail.com",
      avatarUrl: "https://i.pravatar.cc/150?img=3",
    ),
    UserData(
      username: "@katya",
      name: "Катя Смирнова",
      email: "katya@ya.ru",
      avatarUrl: "https://i.pravatar.cc/150?img=4",
    ),
  ];

  List<UserData> filteredUsers = [];

  void _onSearchChanged(String query) {
    setState(() {
      filteredUsers =
          allUsers.where((u) {
            final q = query.toLowerCase();
            return u.username.toLowerCase().contains(q) ||
                (u.name?.toLowerCase().contains(q) ?? false) ||
                u.email.toLowerCase().contains(q);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      appBar: AppBar(
        title: const Text(
          "Пригласить в доску",
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
          // Ссылка на доску
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.boardLink));
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
                        widget.boardLink,
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

          const SizedBox(height: 16),

          // Поле поиска
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Введите имя, username или email",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Найденные юзеры вертикально
          Expanded(
            child:
                filteredUsers.isNotEmpty
                    ? ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredUsers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return _UserCard(user: user);
                      },
                    )
                    : _controller.text.isNotEmpty
                    ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Никого не найдено",
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),

          // Кнопка пригласить
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Приглашение отправлено ${_controller.text}",
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Пригласить",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserData {
  final String username;
  final String? name;
  final String email;
  final String avatarUrl;

  UserData({
    required this.username,
    this.name,
    required this.email,
    required this.avatarUrl,
  });
}

class _UserCard extends StatelessWidget {
  final UserData user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          CircleAvatar(
            backgroundImage: NetworkImage(user.avatarUrl),
            radius: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  user.username,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

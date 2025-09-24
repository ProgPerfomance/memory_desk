import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'invite_to_board_view_model.dart';
import 'package:memory_desk/domain/entities/user_entity.dart';

class InviteToBoardView extends StatefulWidget {
  final String boardLink;
  final String deskId;
  const InviteToBoardView({
    super.key,
    required this.boardLink,
    required this.deskId,
  });

  @override
  State<InviteToBoardView> createState() => _InviteToBoardViewState();
}

class _InviteToBoardViewState extends State<InviteToBoardView> {
  final TextEditingController _controller = TextEditingController();

  void _onSearchChanged(BuildContext context, String query) {
    final vm = context.read<InviteToBoardViewModel>();
    vm.searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InviteToBoardViewModel>();

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
              onChanged: (q) => _onSearchChanged(context, q),
              decoration: InputDecoration(
                hintText: "Введите имя, username или email",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Найденные юзеры
          Expanded(
            child:
                vm.users.isNotEmpty
                    ? ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: vm.users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = vm.users[index];
                        return _UserCard(user: user, deskId: widget.deskId);
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

class _UserCard extends StatelessWidget {
  final UserEntity user;
  final String deskId;
  const _UserCard({required this.user, required this.deskId});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InviteToBoardViewModel>(context);
    return GestureDetector(
      onTap: () {
        vm.inviteUserToDesk(user.id, deskId);
      },
      child: Container(
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
              backgroundImage:
                  user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
              radius: 28,
              child: user.avatarUrl == null ? const Icon(Icons.person) : null,
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
      ),
    );
  }
}

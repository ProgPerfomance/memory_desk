import 'package:flutter/material.dart';

class MyInvitesView extends StatefulWidget {
  const MyInvitesView({super.key});

  @override
  State<MyInvitesView> createState() => _MyInvitesViewState();
}

class _MyInvitesViewState extends State<MyInvitesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final active = [
    InviteData(
      boardName: "Семейный альбом",
      invitedBy: "@masha",
      status: "active",
      avatarUrl: "https://i.pravatar.cc/150?img=2",
      date: "20.09.2025",
    ),
  ];

  final accepted = [
    InviteData(
      boardName: "Поездка в Португалию",
      invitedBy: "@petr",
      status: "accepted",
      avatarUrl: "https://i.pravatar.cc/150?img=3",
      date: "15.09.2025",
    ),
  ];

  final declined = [
    InviteData(
      boardName: "Рабочая доска",
      invitedBy: "@katya",
      status: "declined",
      avatarUrl: "https://i.pravatar.cc/150?img=4",
      date: "10.09.2025",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5ED),
      appBar: AppBar(
        title: const Text(
          "Мои приглашения",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: "Активные"),
            Tab(text: "Принятые"),
            Tab(text: "Отклонённые"),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(active, "Нет активных приглашений"),
          _buildList(accepted, "Нет принятых приглашений"),
          _buildList(declined, "Нет отклонённых приглашений"),
        ],
      ),
    );
  }

  Widget _buildList(List<InviteData> items, String emptyText) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final invite = items[index];
        return _InviteCard(invite: invite);
      },
    );
  }
}

class InviteData {
  final String boardName;
  final String invitedBy;
  final String status;
  final String avatarUrl;
  final String date;

  InviteData({
    required this.boardName,
    required this.invitedBy,
    required this.status,
    required this.avatarUrl,
    required this.date,
  });
}

class _InviteCard extends StatelessWidget {
  final InviteData invite;
  const _InviteCard({required this.invite});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText;

    switch (invite.status) {
      case "active":
        badgeColor = Colors.orange;
        badgeText = "Ожидает ответа";
        break;
      case "accepted":
        badgeColor = Colors.green;
        badgeText = "Принято";
        break;
      case "declined":
        badgeColor = Colors.red;
        badgeText = "Отклонено";
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = "";
    }

    return Container(
      padding: const EdgeInsets.all(14),
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
            backgroundImage: NetworkImage(invite.avatarUrl),
            radius: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invite.boardName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Пригласил: ${invite.invitedBy}",
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  invite.date,
                  style: const TextStyle(fontSize: 12, color: Colors.black38),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 12,
                color: badgeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

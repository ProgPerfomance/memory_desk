import 'package:flutter/material.dart';
import 'package:memory_desk/domain/entities/invite_desk_entity.dart';
import 'package:memory_desk/presentation/gallery/gallery_view.dart';
import 'package:provider/provider.dart';

import 'my_invites_view_model.dart';

class MyInvitesView extends StatefulWidget {
  const MyInvitesView({super.key});

  @override
  State<MyInvitesView> createState() => _MyInvitesViewState();
}

class _MyInvitesViewState extends State<MyInvitesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    Future.microtask(() {
      final vm = context.read<MyInvitesViewModel>();
      vm.loadInvites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MyInvitesViewModel>(context);
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
          _buildList(vm.activeInvites, "Нет активных приглашений"),
          _buildList(vm.acceptedInvites, "Нет принятых приглашений"),
          _buildList(vm.declinedInvites, "Нет отклонённых приглашений"),
        ],
      ),
    );
  }

  Widget _buildList(List<InviteDeskEntity> items, String emptyText) {
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

class _InviteCard extends StatelessWidget {
  final InviteDeskEntity invite;
  const _InviteCard({required this.invite});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText;

    switch (invite.status) {
      case "pending":
        badgeColor = Colors.orange;
        badgeText = "Ожидает ответа";
        break;
      case "approved":
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

    return GestureDetector(
      onTap: () {
        if (invite.status == "approved") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      GalleryView(deskId: invite.deskId, desk: invite.desk!),
            ),
          );
        }
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(invite.user?.avatarUrl ?? ""),
                  radius: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invite.desk?.name ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Пригласил: ${invite.user?.name ?? ""}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (invite.status != "pending")
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
            if (invite.status == "pending") ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.read<MyInvitesViewModel>().declineInvite(
                        invite.id,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text("Отклонить"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MyInvitesViewModel>().acceptInvite(
                        invite.id,
                        invite.recipientId,
                        invite.deskId,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Принять"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

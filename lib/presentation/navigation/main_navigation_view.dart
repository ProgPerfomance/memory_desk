import 'package:flutter/material.dart';
import 'package:memory_desk/presentation/create_desk/step_1_view.dart';
import 'package:memory_desk/presentation/desk_list/desk_list_view.dart';
import 'package:memory_desk/presentation/love/love_view.dart';
import 'package:memory_desk/presentation/my_invites/my_invites_view.dart';
import 'package:memory_desk/presentation/profile/profile_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    BoardsListView(),
    MyInvitesView(),
    Step1View(),
    LoveView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onCenterButtonTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => const Scaffold(body: Center(child: Text("Экран создания"))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _onCenterButtonTap();
          } else {
            _onItemTapped(index);
          }
        },
        avatarUrl: "",
        userNameOrEmail: "Barsik",
      ),
    );
  }
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String? avatarUrl;
  final String? userNameOrEmail;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.avatarUrl,
    this.userNameOrEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color(0xCC2F3032), // #2F3032 80%
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIcon(Icons.dashboard, 0, "Главная"),
          _buildIcon(Icons.group, 1, "Запросы"),
          _buildCenterButton(context),
          _buildIcon(Icons.favorite, 3, "Любимый"),
          _buildProfileIcon(4),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index, String label) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xffFFD5A4) : Colors.white70,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xffFFD5A4) : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Step1View()),
        );
      },
      child: Container(
        height: 62,
        width: 62,
        decoration: const BoxDecoration(
          color: Color(0xffFFD5A4),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.black, size: 36),
      ),
    );
  }

  Widget _buildProfileIcon(int index) {
    final isActive = currentIndex == index;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: () => onTap(index),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(avatarUrl!),
        ),
      );
    } else {
      final letter =
          (userNameOrEmail?.isNotEmpty ?? false)
              ? userNameOrEmail!.substring(0, 1).toUpperCase()
              : "?";
      return GestureDetector(
        onTap: () => onTap(index),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xffFFD5A4),
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}

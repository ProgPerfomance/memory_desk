import 'package:flutter/material.dart';
import 'package:memory_desk/core/theme/colors.dart'; // AppColors.background = #FAF5ED

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    this.name,
    required this.email,
    this.avatarUrl,
    this.onSignOut,
    this.onDeleteAccount,
    this.onOpenPrivacy,
    this.onOpenTerms,
  });

  final String? name;
  final String email;
  final String? avatarUrl;

  final VoidCallback? onSignOut;
  final VoidCallback? onDeleteAccount;
  final VoidCallback? onOpenPrivacy;
  final VoidCallback? onOpenTerms;

  @override
  Widget build(BuildContext context) {
    const _textPrimary = Color(0xFF333333);
    const _textSecondary = Color(0xFF808080);
    const _danger = Color(0xFFFA1654);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Назад',
        ),
        centerTitle: true,
        title: const Text(
          'Профиль',
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Шапка профиля
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                _Avatar(
                  avatarUrl: avatarUrl,
                  fallbackText: _initials(name, email),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _HeaderBlock(
                    name: name,
                    email: email,
                    textPrimary: _textPrimary,
                    textSecondary: _textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Нижние действия (плоские строки с разделителями)
          _ActionRow(
            icon: Icons.exit_to_app,
            label: 'Выйти',
            onTap: onSignOut,
            textColor: _textPrimary,
          ),
          const _ThinDivider(),
          _ActionRow(
            icon: Icons.delete_outline,
            label: 'Удалить аккаунт',
            onTap: onDeleteAccount,
            textColor: _danger,
          ),
          const _ThinDivider(),
          _ActionRow(
            icon: Icons.privacy_tip_outlined,
            label: 'Политика конфиденциальности',
            onTap: onOpenPrivacy,
            textColor: _textPrimary,
          ),
          const _ThinDivider(),
          _ActionRow(
            icon: Icons.article_outlined,
            label: 'Пользовательское соглашение',
            onTap: onOpenTerms,
            textColor: _textPrimary,
          ),

          // Отступ под нижний инсет
          const SafeArea(top: false, child: SizedBox(height: 8)),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.avatarUrl, required this.fallbackText});

  final String? avatarUrl;
  final String fallbackText;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 36,
      backgroundColor: const Color(0xFFE8E2D8),
      backgroundImage:
          avatarUrl != null && avatarUrl!.isNotEmpty
              ? NetworkImage(avatarUrl!)
              : null,
      child:
          (avatarUrl == null || avatarUrl!.isEmpty)
              ? Text(
                fallbackText,
                style: const TextStyle(
                  color: Color(0xFF6B6B6B),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              )
              : null,
    );
  }
}

class _HeaderBlock extends StatelessWidget {
  const _HeaderBlock({
    required this.name,
    required this.email,
    required this.textPrimary,
    required this.textSecondary,
  });

  final String? name;
  final String email;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final hasName = name != null && name!.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasName)
          Text(
            name!.trim(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        Text(
          email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: hasName ? textSecondary : textPrimary,
            fontSize: hasName ? 14 : 18,
            fontWeight: hasName ? FontWeight.w400 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // без заливки и всплесков, максимально “плоско”
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: textColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE6DED2), // тонкий тёплый разделитель
    );
  }
}

// ----- helpers -----

String _initials(String? name, String email) {
  final base =
      (name == null || name.trim().isEmpty) ? email.split('@').first : name;
  final parts =
      base.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (parts.isEmpty) return 'U';
  if (parts.length == 1) return parts.first.characters.first.toUpperCase();
  return (parts.first.characters.first + parts.last.characters.first)
      .toUpperCase();
}

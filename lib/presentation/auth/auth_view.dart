import 'package:flutter/material.dart';
import 'package:memory_desk/presentation/auth/auth_view_model.dart';
import 'package:memory_desk/presentation/desk_list/desk_list_view.dart';
import 'package:provider/provider.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  void _vkTap() {}
  void _loginTap() {}

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "The Moments",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 48),

              _LabeledField(
                label: "Email",
                icon: Icons.email_outlined,
                obscure: false,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              _LabeledField(
                controller: _passwordController,
                label: "Пароль",
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 24),

              _PrimaryButton(
                text: "Войти",
                onTap: () async {
                  final bool success = await vm.loginUserWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );
                  print(success);
                  if (success == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BoardsListView()),
                    );
                  }
                },
              ),
              const SizedBox(height: 32),

              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("или"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  // Expanded(
                  //   child: _SocialButton(
                  //     text: "VK",
                  //     icon: Icons.people,
                  //     background: const Color(0xFF2787F5),
                  //     textColor: Colors.white,
                  //     borderColor: Colors.transparent,
                  //     onTap: _vkTap,
                  //   ),
                  // ),
                  // const SizedBox(width: 16),
                  Expanded(
                    child: _SocialButton(
                      text: "Google",
                      icon: Icons.mail,
                      background: Colors.white,
                      textColor: Colors.black87,
                      borderColor: Colors.black12,
                      onTap: () async {
                        bool success = await vm.loginUserWithGoogle();
                        if (success == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoardsListView(),
                            ),
                          );
                          //  if (!context.mounted) return;
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                          //   Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (_) => const BoardsListView(),
                          //     ),
                          //     (route) => false,
                          //   );
                          // });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Поле ввода с лейблом и иконкой (без логики)
class _LabeledField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscure;
  final TextEditingController controller;
  const _LabeledField({
    required this.label,
    required this.icon,
    required this.obscure,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Универсальная «основная» кнопка как контейнер
class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Соц-кнопка в одну линию (иконка + текст), тоже на контейнерах
class _SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color background;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.background,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: textColor),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

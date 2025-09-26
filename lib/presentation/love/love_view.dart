import 'package:flutter/material.dart';
import 'package:memory_desk/core/theme/colors.dart';
import 'package:memory_desk/core/theme/text_styles.dart';

class LoveView extends StatelessWidget {
  const LoveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Два аватара + сердце + дни
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPerson("assets/images/avatar_me.png", "Я"),
                  Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.redAccent, size: 36),
                      const SizedBox(height: 6),
                      Text(
                        "365 дней",
                        style: AppTextStyles.h4.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  _buildPerson("assets/images/avatar_love.png", "Любимый"),
                ],
              ),

              const Spacer(),

              // Кнопка
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFFD5A4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Навигация к приватной доске
                  },
                  child: Text(
                    "Наши воспоминания",
                    style: AppTextStyles.h4.copyWith(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerson(String avatarPath, String name) {
    return Column(
      children: [
        Container(
          height: 84,
          width: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.1),
            image: DecorationImage(
              image: AssetImage(avatarPath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: AppTextStyles.h4.copyWith(color: Colors.black)),
      ],
    );
  }
}

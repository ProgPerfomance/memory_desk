import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memory_desk/core/theme/text_styles.dart';
import 'package:memory_desk/presentation/onboarding/onboarding_three_view.dart';

class OnboardingTwoView extends StatelessWidget {
  const OnboardingTwoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onb_2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                top: MediaQuery.of(context).size.height / 2,
                bottom: 0,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 8.7, sigmaY: 8.7),
                  child: Container(
                    height: 48,
                    width: 48,
                    color: Color(0xffFFB265).withAlpha(38),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24,
                      ),
                      child: Text("THE MEMORIES", style: AppTextStyles.h3),
                    ),
                    Spacer(),
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "История вашей\nлюбви",
                              style: AppTextStyles.h3,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Собирай самые важные моменты вдвоём и возвращайся к ним снова и снова.",
                              style: AppTextStyles.body16,
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => OnboardingThreeView(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 48,
                                  width: 118,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/blur_btn.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Далее",
                                      style: AppTextStyles.h4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

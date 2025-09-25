import 'package:flutter/material.dart';
import 'package:memory_desk/core/theme/text_styles.dart';

class OnboardingOneView extends StatelessWidget {
  const OnboardingOneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onb_1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(height: 24),
              Container(
                height: 48,
                width: 248,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/images/logo_blur.png"),
                //     fit: BoxFit.cover,
                //     opacity: 0.5,
                //   ),
                // ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 24,
                  ),
                  child: Text("THE MEMORIES", style: AppTextStyles.h3),
                ),
              ),
              Spacer(),
              Container(
                height: 350,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/onb_blur.png"),
                    fit: BoxFit.cover,
                    // opacity: 0.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Сохраняй моменты с друзьями",
                        style: AppTextStyles.h3,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Делись воспоминаниями с близкими и храни самые тёплые дни вместе.",
                        style: AppTextStyles.body16,
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 48,
                          width: 118,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/blur_btn.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(child: Text("Далее")),
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
      ),
    );
  }
}

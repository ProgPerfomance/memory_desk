import 'package:flutter/material.dart';
import 'package:memory_desk/presentation/navigation/main_navigation_view.dart';
import 'package:memory_desk/presentation/onboarding/onboarding_one_view.dart';
import 'package:provider/provider.dart';
import 'loading_view_model.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LoadingViewModel>();

    return FutureBuilder<String>(
      future: vm.loadInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data == "/main") {
          return const MainNavigationView();
        } else if (!snapshot.hasData || snapshot.data == "/auth") {
          return const OnboardingOneView();
        }
        return OnboardingOneView();
      },
    );
  }
}

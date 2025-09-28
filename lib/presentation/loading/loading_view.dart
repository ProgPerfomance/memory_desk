import 'package:flutter/material.dart';
import 'package:memory_desk/presentation/navigation/main_navigation_view.dart';
import 'package:memory_desk/presentation/onboarding/onboarding_one_view.dart';
import 'package:provider/provider.dart';
import '../auth/auth_view.dart';
import '../desk_list/desk_list_view.dart';
import 'loading_view_model.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LoadingViewModel>();

    return FutureBuilder<bool>(
      future: vm.loadUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          return const MainNavigationView();
        } else {
          return const OnboardingOneView();
        }
      },
    );
  }
}

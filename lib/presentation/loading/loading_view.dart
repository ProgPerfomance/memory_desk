import 'package:flutter/material.dart';
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
          return const BoardsListView();
        } else {
          return const AuthView();
        }
      },
    );
  }
}

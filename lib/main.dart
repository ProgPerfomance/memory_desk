import 'package:flutter/material.dart';
import 'package:memory_desk/presentation/create_desk/create_desk_view_model.dart';
import 'package:memory_desk/presentation/create_desk/step_1_view.dart';
import 'package:memory_desk/presentation/desk_list/desk_list_view.dart';
import 'package:memory_desk/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  register();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CreateDeskViewModel()),
      ],
      child: MaterialApp(
        home: BoardsListView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

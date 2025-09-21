import 'package:flutter/material.dart';
import 'package:memory_desk/presentation/add_images/add_image_view_model.dart';
import 'package:memory_desk/presentation/auth/auth_view.dart';
import 'package:memory_desk/presentation/auth/auth_view_model.dart';
import 'package:memory_desk/presentation/create_desk/create_desk_view_model.dart';
import 'package:memory_desk/presentation/desk_list/desk_list_view.dart';
import 'package:memory_desk/presentation/desk_list/desk_list_view_model.dart';
import 'package:memory_desk/presentation/gallery/gallery_view_model.dart';
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
        ChangeNotifierProvider(create: (context) => DeskListViewModel()),
        ChangeNotifierProvider(create: (context) => GalleryViewModel()),
        ChangeNotifierProvider(create: (context) => UploadPhotosViewModel()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
      ],
      child: MaterialApp(home: AuthView(), debugShowCheckedModeBanner: false),
    );
  }
}

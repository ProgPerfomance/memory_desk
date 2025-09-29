import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:memory_desk/data/repository/desk_repository.dart';
import 'package:memory_desk/presentation/gallery/gallery_view.dart';
import 'package:memory_desk/service_locator.dart';

import '../main.dart'; // здесь у тебя хранится navigatorKey

class DeepLinkListener extends StatefulWidget {
  final Widget child;
  const DeepLinkListener({super.key, required this.child});

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    final DeskRepository deskRepository = getIt.get<DeskRepository>();

    // Слушаем только ссылки во время жизни приложения
    _sub = _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri, deskRepository),
      onError: (err) => debugPrint("Deep link error: $err"),
    );
  }

  Future<void> _handleUri(Uri uri, DeskRepository deskRepository) async {
    debugPrint("Got deep link: $uri");

    if (uri.pathSegments.isEmpty) return;

    switch (uri.pathSegments.first) {
      case 'gallery':
        final id = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
        if (id != null) {
          try {
            final desk = await deskRepository.getDeskById(id);
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => GalleryView(deskId: id, desk: desk),
              ),
            );
          } catch (e, st) {
            debugPrint("Failed to load desk $id: $e\n$st");
          }
        }
        break;

      // case 'invite':
      //   navigatorKey.currentState?.pushNamed('/invite');
      //   break;
      //
      // default:
      //   navigatorKey.currentState?.pushNamed('/main');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

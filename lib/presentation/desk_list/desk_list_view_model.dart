import 'package:flutter/material.dart';
import 'package:memory_desk/data/repository/desk_repository.dart';
import 'package:memory_desk/service_locator.dart';

class DeskListViewModel extends ChangeNotifier {
  final DeskRepository _deskRepository = getIt.get<DeskRepository>();

  Future<void> load() async {}
}

import 'package:get_it/get_it.dart';
import 'package:memory_desk/data/repository/desk_invites_repository.dart';
import 'package:memory_desk/data/repository/desk_repository.dart';
import 'package:memory_desk/data/repository/user_repository.dart';

GetIt getIt = GetIt.instance;

void register() {
  getIt.registerSingleton(DeskRepository());
  getIt.registerSingleton(UserRepository());
  getIt.registerSingleton(DeskInvitesRepository());
}

Future<void> resetDI() async {
  await getIt.reset();
  register();
}

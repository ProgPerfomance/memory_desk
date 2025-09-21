import 'package:shared_preferences/shared_preferences.dart';

class UserIdService {
  static Future<void> saveUserId(String userId) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setString("userId", userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String? userId = await sharedPreferences.getString("userId");
    return userId;
  }
}

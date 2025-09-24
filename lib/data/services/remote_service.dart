import 'package:dio/dio.dart';
import 'package:memory_desk/core/api_routes.dart';
import 'package:memory_desk/domain/entities/desk_entity.dart';

class RemoteService {
  static final dio = Dio(BaseOptions(baseUrl: baseUrl));

  static Future<Response> createDesk(Map data) async {
    final response = await dio.post("/desk/create", data: data);
    return response;
  }

  static Future<Response> getUserDesks(String userId) async {
    final response = await dio.get("/desk/user/$userId");
    return response;
  }

  static Future<Response> uploadDeskImages(Map data) async {
    final response = await dio.post("/desk/images/add", data: data);
    return response;
  }

  static Future<Response> loadImagesOnDesk(String deskId) async {
    final response = await dio.get("/desk/images/$deskId");
    return response;
  }

  static Future<Response> loginUserByEmailAndPassword(
    String email,
    String password,
  ) async {
    final response = await dio.post(
      "/users/login/email",
      data: {"email": email, "password": password},
    );
    return response;
  }

  static Future<Response> loginUserByGoogle(String email, String name) async {
    final response = await dio.post(
      "/users/login/google",
      data: {"email": email, "name": name},
    );
    return response;
  }

  static Future<Response> getUserById(String userId) async {
    final response = await dio.get("/users/get/$userId");
    return response;
  }

  static Future<Response> updateDesk(Map data) async {
    final response = await dio.put("/desk/update", data: data);
    return response;
  }

  static Future<Response> getMyInvites(String userId) async {
    final response = await dio.get("/invites/list/$userId");
    return response;
  }

  static Future<Response> sendInvite(Map data) async {
    final response = await dio.post("/invites/send", data: data);
    return response;
  }

  static Future<Response> approveInvite(
    String inviteId,
    String recipientId,
    String deskId,
  ) async {
    final response = await dio.put(
      "/invites/approve/$inviteId/$recipientId/$deskId",
    );
    return response;
  }

  static Future<Response> declineInvite(String inviteId) async {
    final response = await dio.put("/invites/decline/$inviteId");
    return response;
  }

  static Future<Response> searchUsers(String query) async {
    final response = await dio.post("/users/search", data: {"query": query});
    return response;
  }
}

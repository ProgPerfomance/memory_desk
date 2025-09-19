import 'package:dio/dio.dart';
import 'package:memory_desk/core/api_routes.dart';

class RemoteService {
  static final dio = Dio(BaseOptions(baseUrl: baseUrl));

  static Future<Response> createDesk(Map data) async {
    final response = await dio.post("/desk/create", data: data);
    return response;
  }
}

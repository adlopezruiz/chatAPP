import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/users_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final resp =
          await http.get(Uri.parse('${Environment.apiUrl}/users'), headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      });

      final usersResponse = usersResponseFromJson(resp.body);

      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}

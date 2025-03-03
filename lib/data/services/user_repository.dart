import '../models/user_model.dart';
import 'package:crud_project/data/services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<bool> login(String email, String password) async {
    try {
      final response = await apiService.post('/login', {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200 && response.data['token'] != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final response = await apiService.post('/register', {
        'email': email,
        'password': password,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await apiService.get('/users');
      if (response.statusCode == 200) {
        final List<UserModel> users =
            (response.data['data'] as List)
                .map((user) => UserModel.fromJson(user))
                .toList();
        return users;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateUser(int id, String firstName, String email) async {
    try {
      final response = await apiService.put('/users/$id', {
        'first_name': firstName,
        'email': email,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final response = await apiService.delete('/users/$id');
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}

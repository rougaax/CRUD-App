import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import '../data/services/user_repository.dart';
import '../data/services/api_service.dart';
import 'dart:math';
import '../utils/snackbar_utils.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository(ApiService());
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isAddingUser = false.obs;
  final RxBool isUpdatingUser = false.obs;
  final RxBool isDeletingUser = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUsers = prefs.getString('users');
      if (storedUsers != null) {
        List<dynamic> decoded = jsonDecode(storedUsers);
        users.value = decoded.map((user) => UserModel.fromJson(user)).toList();
      }

      final apiUsers = await _userRepository.getUsers();
      if (apiUsers.isNotEmpty) {
        for (var apiUser in apiUsers) {
          if (!users.any((u) => u.email == apiUser.email)) {
            users.add(apiUser);
          }
        }
        await saveUsersToPrefs();
      }
    } catch (e) {
      error.value = 'Failed to load users';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUser(String email, String firstName, String lastName) async {
    isAddingUser.value = true;
    try {
      if (!email.endsWith('@reqres.in')) {
        error.value = 'Email must use @reqres.in domain';
        return;
      }
      if (users.any((user) => user.email == email)) {
        error.value = 'Email already exists';
        return;
      }
      final randomId = Random().nextInt(12) + 1;
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch,
        email: email,
        firstName: firstName,
        lastName: lastName,
        avatar: 'https://reqres.in/img/faces/$randomId-image.jpg',
      );
      await _userRepository.register(email, 'password');
      users.add(newUser);
      await saveUsersToPrefs();
      Get.back();
      showSuccessSnackbar("User added successfully");
    } catch (e) {
      error.value = 'Failed to add user';
    } finally {
      isAddingUser.value = false;
    }
  }

  Future<void> updateUser(UserModel user) async {
    isUpdatingUser.value = true;
    try {
      await _userRepository.updateUser(user.id!, user.firstName!, user.email!);
      final index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        users[index] = UserModel(
          id: user.id,
          email: user.email,
          firstName: user.firstName ?? users[index].firstName,
          lastName: user.lastName ?? users[index].lastName,
          avatar: user.avatar ?? users[index].avatar,
        );
        await saveUsersToPrefs();
        Get.back();
        showSuccessSnackbar("User updated successfully");
      }
    } catch (e) {
      error.value = 'Failed to update user';
    } finally {
      isUpdatingUser.value = false;
    }
  }

  Future<void> deleteUser(int id) async {
    isDeletingUser.value = true;
    try {
      await _userRepository.deleteUser(id);
      users.removeWhere((user) => user.id == id);
      await saveUsersToPrefs();
      showSuccessSnackbar("User deleted successfully");
    } catch (e) {
      error.value = 'Failed to delete user';
    } finally {
      isDeletingUser.value = false;
    }
  }

  Future<void> saveUsersToPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String usersJson = jsonEncode(
        users.map((user) => user.toJson()).toList(),
      );
      await prefs.setString('users', usersJson);
    } catch (e) {
      error.value = 'Failed to save users';
    }
  }
}

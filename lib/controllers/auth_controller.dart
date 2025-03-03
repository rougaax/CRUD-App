import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/user_repository.dart';
import '../data/services/api_service.dart';
import '../utils/snackbar_utils.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  final UserRepository _userRepository = UserRepository(ApiService());

  @override
  void onInit() async {
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool("isLoggedIn") ?? false;
    if (isLoggedIn.value) Get.offAllNamed("/home");
  }

  Future<void> login(String email, String password) async {
    final loginResponse = await _userRepository.login(email, password);
    if (loginResponse) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      await prefs.setString("userEmail", email);
      Get.offAllNamed("/home");
    } else {
      showErrorSnackbar("Invalid email or password");
    }
  }

  Future<void> register(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> registeredEmails =
        prefs.getStringList("registeredEmails") ?? [];

    if (registeredEmails.contains(email)) {
      showErrorSnackbar("Email already registered. Please login.");
      return;
    }

    final registerResponse = await _userRepository.register(email, password);
    if (registerResponse) {
      registeredEmails.add(email);
      await prefs.setStringList("registeredEmails", registeredEmails);

      showSuccessSnackbar("Register Successful");
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    } else {
      showErrorSnackbar("Registration failed. Please try again.");
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    Get.offAllNamed("/login");
  }
}

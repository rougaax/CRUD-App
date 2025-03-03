import 'package:get/get.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/home_view.dart';
import '../views/add_user_view.dart';
import '../views/update_user_view.dart';

class AppRoutes {
  static const login = "/login";
  static const register = "/register";
  static const home = "/home";
  static const addUser = "/add-user";
  static const updateUser = "/update-user";

  static final routes = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: register, page: () => RegisterView()),
    GetPage(name: home, page: () => HomeView()),
    GetPage(name: addUser, page: () => AddUserView()),
    GetPage(name: updateUser, page: () => UpdateUserView()),
  ];
}

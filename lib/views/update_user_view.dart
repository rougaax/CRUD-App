import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../data/models/user_model.dart';
import '../widgets/custom_text_field.dart';

class UpdateUserView extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  late final UserModel user;

  UpdateUserView({super.key}) {
    user = Get.arguments;
    initializeTextFields();
  }

  void initializeTextFields() {
    emailController.text = user.email ?? '';
    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
  }

  void updateUser() {
    if (emailController.text.isEmpty || firstNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red.withAlpha(230),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final updatedUser = UserModel(
      id: user.id,
      email: emailController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName:
          lastNameController.text.trim().isEmpty
              ? null
              : lastNameController.text.trim(),
      avatar: user.avatar,
    );

    userController.updateUser(updatedUser);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Update User', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: firstNameController,
              label: 'First Name',
              icon: Icons.person,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: lastNameController,
              label: 'Last Name (Optional)',
              icon: Icons.person_outline,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: updateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update User',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

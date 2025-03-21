import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../widgets/custom_text_field.dart';

class AddUserView extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  AddUserView({super.key}) {
    initializeControllers();
  }

  void initializeControllers() {
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
  }

  void validateAndAddUser() {
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

    userController.addUser(
      emailController.text.trim(),
      firstNameController.text.trim(),
      lastNameController.text.trim().isEmpty
          ? ""
          : lastNameController.text.trim(),
    );

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add User', style: TextStyle(color: Colors.white)),
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
                onPressed: validateAndAddUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add User',
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

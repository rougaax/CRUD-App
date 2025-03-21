import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../data/models/user_model.dart';

class HomeView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final UserController userController = Get.put(UserController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('CRUD APP', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(
        () =>
            userController.isLoading.value
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : userController.users.isEmpty
                ? const Center(
                  child: Text(
                    'No Users Available',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  itemCount: userController.users.length,
                  itemBuilder: (context, index) {
                    final user = userController.users[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundImage:
                              user.avatar != null && user.avatar!.isNotEmpty
                                  ? NetworkImage(user.avatar!)
                                  : null,
                          backgroundColor: Colors.white10,
                          child:
                              user.avatar == null || user.avatar!.isEmpty
                                  ? const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          user.email ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed:
                                  () => Get.toNamed(
                                    '/update-user',
                                    arguments: user,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed:
                                  () => showDeleteConfirmation(context, user),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-user'),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void showDeleteConfirmation(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Delete User',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to delete ${user.firstName}?',
              style: const TextStyle(color: Colors.grey),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  userController.deleteUser(user.id!);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

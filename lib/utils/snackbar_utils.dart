import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(String title, String message, Color color) {
  Future.delayed(Duration.zero, () {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color.withAlpha(230),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  });
}

void showSuccessSnackbar(String message) {
  showSnackbar("Success", message, Colors.green);
}

void showErrorSnackbar(String message) {
  showSnackbar("Error", message, Colors.red);
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_admin/data.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/utils/widgets/nav_bar.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List loginLogos = [IconsConstants.googleIcon, IconsConstants.facebookIcon];

  login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      Get.snackbar("Error", "Please Enter Email and Password");
    } else {
      if (email == "khadeeja@gmail.com" && password == "123456") {
        box.write("isLogin", true);
        Get.offAll(() => MyBottomNavbar());
      } else if (email == "iqra@gmail.com" && password == "123456") {
        box.write("isLogin", true);
        Get.offAll(() => MyBottomNavbar());
      } else if (email == "test@gmail.com" && password == "123456") {
        box.write("isLogin", true);
        Get.offAll(() => MyBottomNavbar());
      } else {
        Get.snackbar("Error", "Invalid Email or Password");
      }
    }
  }
}

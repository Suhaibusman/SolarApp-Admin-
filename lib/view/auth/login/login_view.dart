// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solar_admin/controller/login_controller.dart';
import 'package:solar_admin/utils/constants/app_constant.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/utils/widgets/custom_button.dart';
import 'package:solar_admin/utils/widgets/custom_textfield.dart';
import 'package:solar_admin/utils/widgets/text_widget.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  LoginController loginController = Get.put(LoginController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primarycolor,
        body: Stack(
          children: [
            SvgPicture.asset(
              SvgConstants.homeBg,
              width: Get.width,
              fit: BoxFit.fill,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                ImageConstants.loginImage,
                width: Get.width * 0.47,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: Get.height * 0.06,
                    right: 20,
                    bottom: 10,
                  ),
                  width: double.maxFinite,
                  height: Get.height * 0.78,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                    ),
                    color: const Color(0xff0D1721).withOpacity(.7),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        smallSpace,
                        Center(
                          child: ctext(
                            text: "Welcome Back!",
                            fontWeight: FontWeight.bold,
                            color: white,
                            fontSize: 32,
                          ),
                        ),
                        Center(
                          child: ctext(
                            text: "welcome back we missed you",
                            fontWeight: FontWeight.w500,
                            color: lightPrimaryTextColor,
                            fontSize: 13,
                          ),
                        ),
                        mediumSpace,
                        ctext(
                          text: "Email Address",
                          fontWeight: FontWeight.w600,
                          color: lightPrimaryTextColor,
                          fontSize: 13,
                        ),
                        CustomBorderTextField(
                          obscureText: false,
                          controller: loginController.emailController,
                          hint: 'Email',
                          prefix: Icon(
                            Icons.email_outlined,
                            color: lightPrimaryTextColor,
                          ),
                          valid: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }

                            return null;
                          },
                        ),
                        smallSpace,
                        ctext(
                          text: "Password",
                          fontWeight: FontWeight.w600,
                          color: lightPrimaryTextColor,
                          fontSize: 13,
                        ),
                        CustomBorderTextField(
                          obscureText: true,
                          controller: loginController.passwordController,
                          hint: 'Password',
                          prefix: Icon(
                            Icons.key,
                            color: lightPrimaryTextColor,
                          ),
                          valid: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        mediumSpace,
                        CustomButton(
                          borderRadius: BorderRadius.circular(15),
                          height: 43,
                          mywidth: 1,
                          onPressed: () {
                            // Get.to(MyBottomNavbar());
                            loginController.login();
                          },
                          child: 'Sign in',
                          gradientColors: [
                            btnPrimaryColor,
                            btnSecondaryColor,
                          ],
                          color: btnSecondaryColor,
                        ),
                        smallSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

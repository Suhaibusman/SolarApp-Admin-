import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/view/welcome/welcome_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const WelcomeView(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      body: Stack(
        children: [
          SvgPicture.asset(
            SvgConstants.homeBg,
            width: Get.width,
            fit: BoxFit.fill,
          ),
          Center(child: Image.asset(IconsConstants.checkIcon)),
        ],
      ),
    );
  }
}

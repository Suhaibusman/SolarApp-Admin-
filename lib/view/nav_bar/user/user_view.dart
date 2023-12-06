import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solar_admin/controller/user_controller.dart';
import 'package:solar_admin/utils/constants/app_constant.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/utils/widgets/text_widget.dart';
import 'package:solar_admin/view/nav_bar/user/product_details_view.dart';

// ignore: must_be_immutable
class ProductView extends StatelessWidget {
  ProductView({super.key});
  ProductController productController = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primarycolor,
        body: Stack(children: [
          SvgPicture.asset(
            SvgConstants.homeBg,
            width: Get.width,
            fit: BoxFit.fill,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                mediumSpace,
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: white,
                    ),
                    smallSpaceh,
                    ctext(
                        text: 'Users',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: white)
                  ],
                ).paddingOnly(left: 20, right: 20, top: 20, bottom: 40),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile();
                          },
                        )))
              ])
        ]));
  }
}

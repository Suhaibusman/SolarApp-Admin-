import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solar_admin/controller/maintainance_controller.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/utils/widgets/text_widget.dart';

// ignore: must_be_immutable
class MaintainanceView extends StatelessWidget {
  MaintainanceView({super.key});

  MaintainanceController maintainanceController =
      Get.put(MaintainanceController());

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBar(
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: white,
                  ),
                ),
                title: ctext(
                  text: 'Mainencance Report',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ).paddingOnly(
                top: 10,
              ),
              Expanded(
                child: FutureBuilder<Widget>(
                  future: maintainanceController.fetchMaintenanceReport(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else {
                        return const Center(child: Text("No User Found"));
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

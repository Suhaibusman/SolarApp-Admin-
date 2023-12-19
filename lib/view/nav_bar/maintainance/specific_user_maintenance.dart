import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solar_admin/controller/maintainance_controller.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/utils/widgets/text_widget.dart';

// ignore: must_be_immutable
class SpecificMaintenanceView extends StatelessWidget {
  final String name;
  final String uid;
  SpecificMaintenanceView({super.key, required this.name, required this.uid});

  MaintainanceController maintainanceController =
      Get.put(MaintainanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
          text: "$name Maintenance Report",
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
              Expanded(
                child: FutureBuilder<Widget>(
                  future: maintainanceController.fetchSpecificUserMaintenance(
                      userId: uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else {
                        return Center(
                          child: ctext(
                            text: "No Maintenance Found",
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else {
                      // Handle other ConnectionState values if needed
                      return const Center(
                          child: Text("Unexpected ConnectionState"));
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

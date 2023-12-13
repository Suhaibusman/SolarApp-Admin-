import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solar_admin/controller/complaint_controller.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/utils/widgets/text_widget.dart';

// ignore: must_be_immutable
class UserComplainView extends StatelessWidget {
  String complainNumber;
  String complainerTitle;
  //  String complainerEmail;
  //  String complainerPhone;
  //  String complainerAddress;
  String complainImage;
  String complainDescription;
  String complainStatus;

  UserComplainView(
      {super.key,
      required this.complainNumber,
      required this.complainerTitle,
      required this.complainImage,
      required this.complainDescription,
      required this.complainStatus});

  ComplaintController complaintController = Get.put(ComplaintController());

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
                  text: 'Complaint Details',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ).paddingOnly(top: 10, bottom: 10),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(complainImage),
              ),
              ctext(
                text: "Complaint Title: $complainerTitle",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: white,
              ),
              ctext(
                text: "Complaint Description: $complainDescription",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: white,
              ),
              ctext(
                text: "Complaint Status: $complainStatus",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: white,
              ),
              ctext(
                text: 'Complaint Number : $complainNumber',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

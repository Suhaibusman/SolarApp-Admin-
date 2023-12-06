import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:solar_admin/utils/constants/app_constant.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/utils/widgets/custom_button.dart';
import 'package:solar_admin/utils/widgets/text_widget.dart';
import 'package:solar_admin/view/nav_bar/complaint_details/complaint_confirmation_view.dart';

class ComplaintController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var selectedValue = 'Urgent'.obs;

  RxList<DateTime> selectedDates = <DateTime>[].obs;
  List<DateTime> multiDatePickerValueWithDefaultValue = [];

  void addDate(DateTime date) {
    selectedDates.add(date);
  }

  void removeDate(DateTime date) {
    selectedDates.remove(date);
  }

  buildDefaultMultiDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
      selectedDayHighlightColor: Colors.indigo,
    );

    return CalendarDatePicker2(
      config: config,
      value: selectedDates.where((date) => date != null).toList(),
      onValueChanged: (dates) {},
    );
  }

  void lodgeComplain(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(25)),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallSpace,
                ctext(
                    text: "Rate us!",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                ctext(
                    text: "We are always here for you",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: lightPrimaryTextColor),
                smallSpace,
                Center(
                  child: RatingBar.builder(
                    itemSize: 32,
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.2),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 13,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ),
                mediumSpace,
                CustomButton(
                  borderRadius: BorderRadius.circular(15),
                  height: 43,
                  mywidth: 1,
                  onPressed: () {
                    Get.to(ComplaintConfirmationView());
                  },
                  child: 'Submit',
                  gradientColors: [
                    btnPrimaryColor,
                    btnSecondaryColor,
                  ],
                  color: btnSecondaryColor,
                ),
                mediumSpace
              ]).paddingSymmetric(horizontal: 15, vertical: 10),
        );
      },
    );
  }

  Future<Widget> fetchWholeData() async {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection("complain").get().asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                //querysnaphot me pora data ayegaa
                String imagePath = doc["profileImage"];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      imagePath == ""
                          ? "https://www.plslwd.org/wp-content/plugins/lightbox/images/No-image-found.jpg"
                          : imagePath,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(doc["username"] ?? "No Name"),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(doc["phoneNumber"] ?? "No Phone Number"),
                    ],
                  ),
                  subtitle: Text(doc["emailAddress"] ?? "No Email"),
                );
              },
            );
          } else {
            return const Center(child: Text("No Data Found"));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

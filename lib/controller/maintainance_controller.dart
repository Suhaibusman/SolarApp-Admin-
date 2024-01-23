// ignore_for_file: deprecated_member_use

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/utils/widgets/custom_button.dart';
import 'package:solar_admin/utils/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintainanceController extends GetxController {
  RxList<DateTime> selectedDates = <DateTime>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DateTime> multiDatePickerValueWithDefaultValue = [];

  // List images = [
  //   ImageConstants.monocrystalineImage,
  //   ImageConstants.polycrystallineImage,
  //   ImageConstants.thinFilmImage,
  // ];
  List maintainanceIcons = [
    Icons.cleaning_services_rounded,
    Icons.battery_2_bar_rounded,
    Icons.inventory
  ];

  List text = ["Cleaning", "Battery", "Inventor"];
  RxInt initialIndex = 0.obs;

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
      // ignore: unnecessary_null_comparison
      value: selectedDates.where((date) => date != null).toList(),
      onValueChanged: (dates) {},
    );
  }

  dateFunction(DocumentSnapshot doc) {
    dynamic dateData = doc['date'][0];

    if (dateData is Timestamp) {
      DateTime complaintDate = dateData.toDate();

      return ctext(
        text: DateFormat('dd-MM-yyyy').format(complaintDate),
        fontWeight: FontWeight.bold,
        fontSize: 11,
        color: Colors.grey.withOpacity(0.6),
      );
    } else {
      // Handle the case where 'date' is not a Timestamp
      return ctext(
        text: 'Invalid date format',
        fontWeight: FontWeight.bold,
        fontSize: 11,
        color: Colors.red, // Choose an appropriate color for an error message
      );
    }
  }

  void openMail({email}) async {
    try {
      String gmailUrl =
          'mailto:$email?subject=Regarding Maintainance&body=Your Maintainance is Approved';
      await launch(gmailUrl);
    } catch (e) {
      Get.snackbar("Error", "Error launching Gmail: $e");
    }
  }

  Future<Widget> fetchSpecificUserMaintenance({required String userId}) async {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection("maintainance")
          .where("uid", isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ctext(
                              text: doc["issue"] ?? "No Issue",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: btnSecondaryColor,
                            ),
                            InkWell(
                              onTap: () {
                                firestore
                                    .collection("maintainance")
                                    .doc(doc.id)
                                    .delete();
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.grey.withOpacity(.6),
                              ),
                            ),
                          ],
                        ),
                        ctext(
                          text: doc["emailAddress"] ?? "No Email",
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // ignore: prefer_interpolation_to_compose_strings
                        Row(
                          children: [
                            ctext(
                              text: "\$" + doc["price"],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ctext(
                              text: doc["phoneNumber"] ?? "No Phone Number",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: btnPrimaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // dateFunction(doc),
                        ctext(text: doc["date"] ?? "No Date"),
                        const SizedBox(
                          width: 10,
                        ),
                        doc["progress"] == "pending"
                            ? CustomButton(
                                borderRadius: BorderRadius.circular(15),
                                height: 43,
                                mywidth: 1,
                                onPressed: () {
                                  try {
                                    firestore
                                        .collection("maintainance")
                                        .doc(doc.id)
                                        .update({"progress": "Approved"}).then(
                                            (value) => openMail(
                                                email: doc["emailAddress"]));
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: 'Approve and Mail',
                                gradientColors: [
                                  btnPrimaryColor,
                                  btnSecondaryColor
                                ],
                                color: btnSecondaryColor)
                            : CustomButton(
                                borderRadius: BorderRadius.circular(15),
                                height: 43,
                                mywidth: 1,
                                onPressed: () {},
                                child: 'Approved',
                                gradientColors: [
                                  btnPrimaryColor,
                                  btnSecondaryColor
                                ],
                                color: btnSecondaryColor),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No Maintenance Found"));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<Widget> fetchMaintenanceReport() async {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection("maintainance").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ctext(
                              text: doc["issue"] ?? "No Issue",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: btnSecondaryColor,
                            ),
                            InkWell(
                              onTap: () {
                                firestore
                                    .collection("maintainance")
                                    .doc(doc.id)
                                    .delete();
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.grey.withOpacity(.6),
                              ),
                            ),
                          ],
                        ),
                        ctext(
                          text: doc["emailAddress"] ?? "No Email",
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // ignore: prefer_interpolation_to_compose_strings
                        Row(
                          children: [
                            ctext(
                              text: "\$" + doc["price"],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ctext(
                              text: doc["phoneNumber"] ?? "No Phone Number",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: btnPrimaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // dateFunction(doc),
                        ctext(text: doc["date"] ?? "No Date"),
                        const SizedBox(
                          width: 10,
                        ),
                        doc["progress"] == "pending"
                            ? CustomButton(
                                borderRadius: BorderRadius.circular(15),
                                height: 43,
                                mywidth: 1,
                                onPressed: () {
                                  try {
                                    firestore
                                        .collection("maintainance")
                                        .doc(doc.id)
                                        .update({"progress": "Approved"}).then(
                                            (value) => openMail(
                                                email: doc["emailAddress"]));
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: 'Approve and Mail',
                                gradientColors: [
                                  btnPrimaryColor,
                                  btnSecondaryColor
                                ],
                                color: btnSecondaryColor)
                            : CustomButton(
                                borderRadius: BorderRadius.circular(15),
                                height: 43,
                                mywidth: 1,
                                onPressed: () {},
                                child: 'Approved',
                                gradientColors: [
                                  btnPrimaryColor,
                                  btnSecondaryColor
                                ],
                                color: btnSecondaryColor),
                      ],
                    ),
                  ),
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

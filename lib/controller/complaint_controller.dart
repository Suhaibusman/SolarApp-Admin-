import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var selectedValue = 'Urgent'.obs;
  String complainid = "hAwbHpKf1lZkVHJBcGvgFrq1sjw1";
  String compainerName = "abc";
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
      // ignore: unnecessary_null_comparison
      value: selectedDates.where((date) => date != null).toList(),
      onValueChanged: (dates) {},
    );
  }

  Stream<List<DocumentSnapshot>> getComplainsStream() {
    CollectionReference userComplain = firestore.collection("complain");

    return userComplain.snapshots().map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      } else {
        return [];
      }
    });
  }

  void deleteComplain(String id) {
    firestore.collection("complain").doc(id).delete();
  }

  void openMail({email, cmpid}) async {
    try {
      String gmailUrl =
          'mailto:$email?subject=Regarding Complain&body=Your Complain $cmpid is Approved';
      await launch(gmailUrl);
    } catch (e) {
      print('Error launching Gmail: $e');
    }
  }
}

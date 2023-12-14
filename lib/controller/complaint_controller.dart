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

  Future<List<DocumentSnapshot>> getComplains() async {
    CollectionReference userComplain = firestore.collection("complain");

    QuerySnapshot complainSnapshot = await userComplain.get();

    if (complainSnapshot.docs.isNotEmpty) {
      return complainSnapshot.docs;
    }
    return [];
  }

  void deleteComplain(String id) {
    firestore.collection("complain").doc(id).delete();
  }

  void openMail({email}) async {
    try {
      String gmailUrl =
          'mailto:$email?subject=Regarding Maintainance&body=Your Maintainance is Approved';
      await launch(gmailUrl);
    } catch (e) {
      print('Error launching Gmail: $e');
    }
  }
}

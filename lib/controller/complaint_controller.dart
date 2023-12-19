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

  Stream<List<Map<String, dynamic>>> getSpecificComplains(uid) {
    // Create a reference to the collection
    CollectionReference userComplain = firestore.collection("complain");

    // Return a stream of snapshots
    return userComplain.snapshots().map((complainSnapshot) {
      List<Map<String, dynamic>> complainDataList = [];

      if (complainSnapshot.docs.isNotEmpty) {
        complainSnapshot.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> complainData =
              document.data() as Map<String, dynamic>;
          // Check if the 'uid' in the document matches the current logged-in UID
          if (complainData['uid'] == uid) {
            complainDataList.add(complainData);
          }
        });
      }

      return complainDataList;
    });
  }
}

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      value: selectedDates.where((date) => date != null).toList(),
      onValueChanged: (dates) {},
    );
  }

  Future<List<DocumentSnapshot>> getComplains() async {
    CollectionReference userComplain = firestore
        .collection("complain")
        .doc(complainid)
        .collection(compainerName);

    QuerySnapshot complainSnapshot = await userComplain.get();

    if (complainSnapshot.docs.isNotEmpty) {
      return complainSnapshot.docs;
    }
    return [];
  }

  void deleteComplain(String id) {
    firestore
        .collection("complain")
        .doc(complainid)
        .collection(compainerName)
        .doc(id)
        .delete();
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

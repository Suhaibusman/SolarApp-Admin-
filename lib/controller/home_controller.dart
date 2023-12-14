// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/view/nav_bar/chat_view/all_chats.dart';
import 'package:solar_admin/view/nav_bar/complaint_details/coplaints_view.dart';
import 'package:solar_admin/view/nav_bar/maintainance/maintainance_view.dart';
import 'package:solar_admin/view/nav_bar/user/user_view.dart';

class HomeController extends GetxController {
  RxInt totalUser = 0.obs;

  RxInt totalComplain = 0.obs;
  RxInt totalMaintainance = 0.obs;
  @override
  void onInit() {
    super.onInit();
    countOfUser();
    countOfmaintainance();
    countOfComplain();
  }

  // ... rest of the code ...

  List grinImagesList = [
    IconsConstants.productIcon,
    IconsConstants.botIcon,
    IconsConstants.complaintIcon,
    IconsConstants.calenderIcon,
    // IconsConstants.contactusIcon,
    // IconsConstants.passwordIcon,
  ];

  List pagesView = [
    UserView(),
    ChatUser(),
    const ComplaintsView(),
    // UserComplainView(),
    MaintainanceView(),
    // SupportView(),
    // ChangePasswordView()
  ];
  List get gridTextList => [
        "totalUser = $totalUser", // Access totalUser without .value during initialization
        "totalChats", // Access totalChats without .value during initialization
        "Complaint = $totalComplain", // Access totalMaintainance without .value during initialization
        "Maintainance = $totalMaintainance",
        // "Contact Us",
        // "Change Password"
      ];

  // ... rest of the code ...

  void countOfUser() {
    FirebaseFirestore.instance.collection('users').get().then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
          totalUser.value = querySnapshot.docs.length;
        } else {
          totalUser.value = 0;
        }
      },
    ).catchError((error) {
      // Handle the error as needed
    });
  }

  countOfComplain() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('complain').get();

      // Extract and print the count value from the QuerySnapshot
      int count = querySnapshot.size;

      // Update the totalComplain value
      totalComplain.value = count;
    } catch (e) {}
  }

  // Future countOfComplain() async {
  //   // Use `doc()` to access an AggregateQuery
  //   AggregateQuery querySnapshot = FirebaseFirestore.instance
  //       .collection('complain')
  //       .doc() as AggregateQuery;

  //   final result = await querySnapshot.get();

  //   // Extract and return the count value from the document
  //   print(" count of complain${result.count}");
  //   totalComplain.value = result.count;
  // }

  void countOfmaintainance() {
    FirebaseFirestore.instance.collection('maintainance').get().then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
          totalMaintainance.value = querySnapshot.docs.length;
        } else {
          totalMaintainance.value = 0;
        }
      },
    ).catchError((error) {
      // Handle the error as needed
    });
  }

//   Future<List<DocumentSnapshot>> getComplains() async {

//     CollectionReference userComplain =
//         firestore.collection("users").doc(userUID).collection("complain");
//     QuerySnapshot complainSbapshot = await userComplain.get();

//     if (complainSbapshot.docs.isNotEmpty) {
//       return complainSbapshot.docs;
//     }
//     return [];
//   }
}

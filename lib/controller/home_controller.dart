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
        "Total User = $totalUser", // Access totalUser without .value during initialization
        "Total Chats", // Access totalChats without .value during initialization
        "Complaint = $totalComplain", // Access totalMaintainance without .value during initialization
        "Maintainance = $totalMaintainance",
        // "Contact Us",
        // "Change Password"
      ];

  // ... rest of the code ...

  void countOfUser() {
    FirebaseFirestore.instance.collection('users').snapshots().listen(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
          // Update the Rx variable with the user count
          totalUser.value = querySnapshot.docs.length;
        } else {
          // Set user count to 0 if no users are found
          totalUser.value = 0;
        }
      },
      onError: (error) {
        // Handle the error as needed
      },
    );
  }

  void countOfComplain() {
    FirebaseFirestore.instance.collection('complain').snapshots().listen(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
          // Update the Rx variable with the user count
          totalComplain.value = querySnapshot.docs.length;
        } else {
          // Set user count to 0 if no users are found
          totalComplain.value = 0;
        }
      },
      onError: (error) {
        // Handle the error as needed
      },
    );
  }

  void countOfmaintainance() {
    FirebaseFirestore.instance.collection('maintainance').snapshots().listen(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
          // Update the Rx variable with the user count
          totalMaintainance.value = querySnapshot.docs.length;
        } else {
          // Set user count to 0 if no users are found
          totalMaintainance.value = 0;
        }
      },
      onError: (error) {
        // Handle the error as needed
      },
    );
  }

  void countOf() {
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
}

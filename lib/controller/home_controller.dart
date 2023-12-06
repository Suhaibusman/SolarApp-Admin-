import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:solar_app/utils/constants/image_constant.dart';
import 'package:solar_app/view/nav_bar/change_password/change_password_view.dart';
import 'package:solar_app/view/nav_bar/chat_view/chat_view.dart';
import 'package:solar_app/view/nav_bar/complaint_details/reg_complaint_view.dart';
import 'package:solar_app/view/nav_bar/maintainance/maintainance_view.dart';
import 'package:solar_app/view/nav_bar/products/product_view.dart';
import 'package:solar_app/view/nav_bar/support/support_view.dart';

class HomeController extends GetxController {
  RxInt totalUser = 0.obs;
  RxInt totalChats = 0.obs;
  @override
  void onInit() {
    super.onInit();
    countOfUser();
    countOfChats();
  }

  // ... rest of the code ...

  List grinImagesList = [
    IconsConstants.productIcon,
    IconsConstants.botIcon,
    IconsConstants.complaintIcon,
    IconsConstants.calenderIcon,
    IconsConstants.contactusIcon,
    IconsConstants.passwordIcon,
  ];

  List pagesView = [
    ProductView(),
    ChatScreen(),
    RegisterComplaintView(),
    MaintainanceView(),
    SupportView(),
    ChangePasswordView()
  ];
  List get gridTextList => [
        "totalUser = $totalUser", // Access totalUser without .value during initialization
        "totalChats =$totalChats", // Access totalChats without .value during initialization
        "Complaint",
        "Maintainance",
        "Contact Us",
        "Change Password"
      ];

  // ... rest of the code ...

  void countOfUser() {
    FirebaseFirestore.instance.collection('users').get().then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
          totalUser.value = querySnapshot.docs.length;
          print("Total Users: $totalUser");
        } else {
          totalUser.value = 0;
          print("No users found.");
        }
      },
    ).catchError((error) {
      print("Error fetching user count: $error");
      // Handle the error as needed
    });
  }

  void countOfChats() {
    FirebaseFirestore.instance.collection('chats').get().then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
          totalChats.value = querySnapshot.docs.length;
          print("Total chats: $totalChats");
        } else {
          totalChats.value = 0;
        }
      },
    ).catchError((error) {
      print("Error fetching user count: $error");
      // Handle the error as needed
    });
  }
}

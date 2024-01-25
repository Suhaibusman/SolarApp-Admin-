import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solar_admin/view/nav_bar/complaint_details/coplaints_view.dart';
import 'package:solar_admin/view/nav_bar/home/home_view.dart';
import 'package:solar_admin/view/nav_bar/maintainance/maintainance_view.dart';
import 'package:solar_admin/view/nav_bar/user/user_view.dart';

class BottomNavBarController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  onInit() {
    _currentScreen = HomeView();
    currentIndex(0);
    super.onInit();
  }

  void onclose() {
    super.onClose();
  }

  Widget _currentScreen = HomeView();

  Widget get currentScreen => _currentScreen;

  void changeScreen(int index) {
    currentIndex(index);
    switch (index) {
      case 0:
        _currentScreen = HomeView();
        break;
      case 1:
        _currentScreen = UserView();
        break;
      case 2:
        _currentScreen = const ComplaintsView();

        break;
      case 3:
        _currentScreen = MaintainanceView();
        break;
      default:
        break;
    }

    update();
  }
}

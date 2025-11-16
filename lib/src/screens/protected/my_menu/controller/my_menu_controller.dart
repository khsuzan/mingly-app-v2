import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../application/venue_menu/model/my_menue_model.dart';
import '../../../../application/venue_menu/repo/menu_repo.dart';

class MyMenuController extends GetxController {
  final menuList = <MyMenuModel>[].obs;
  final expandedIndices = <int>[].obs;

  final isLoading = false.obs;

  final menueRepo = MenueRepo();

  @override
  void onInit() {
    super.onInit();
    fetchMyMenu();
  }

  Future<void> fetchMyMenu() async {
    try {
      isLoading.value = true;
      menuList.value = await menueRepo.getBottle();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error fetching my menu: $e");
      }
    }
  }

  void setExpandedIndices(){

  }
}

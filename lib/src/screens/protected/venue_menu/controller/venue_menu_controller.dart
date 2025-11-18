import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/venues/repo/venues_repo.dart';

import '../../../../application/venue_menu/model/venue_menu_model.dart';

class VenueMenuController extends GetxController {
  final int venueId;
  VenueMenuController({required this.venueId});

  final menuList = <VenueMenuModel>[].obs;
  final isVenueMenuLoading = false.obs;

  final VenuesRepo venueRepo = VenuesRepo();

  @override
  void onInit() {
    super.onInit();
    fetchVenueMenu();
  }

  Future<void> fetchVenueMenu() async {
    try {
      isVenueMenuLoading.value = true;
      final menu = await venueRepo.getVenueMenu(venueId);
      menuList.value = menu;
      isVenueMenuLoading.value = false;
    } catch (e, stack) {
      isVenueMenuLoading.value = false;
      debugPrint("Error fetching venue menu: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  void checkoutToPayment(BuildContext context) {
    //TODO: checkout issue fix
    try {} catch (e) {}
  }
}

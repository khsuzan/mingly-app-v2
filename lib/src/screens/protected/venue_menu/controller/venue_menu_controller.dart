import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/venues/repo/venues_repo.dart';

import '../../../../application/venue_menu/model/venue_menu_model.dart';

class VenueMenuController extends GetxController {
  final int venueId;
  VenueMenuController({required this.venueId});

  final menuList = <VenueMenuModel>[].obs;

  final VenuesRepo venueRepo = VenuesRepo();

  @override
  void onInit() {
    super.onInit();
    fetchVenueMenu();
  }

  Future<void> fetchVenueMenu() async {
    try {
      //TODO: venueid need to dynamic
      final menu = await venueRepo.getVenueMenu(6);
      menuList.value = menu;
    } catch (e, stack) {
      debugPrint("Error fetching venue menu: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  void checkoutToPayment(BuildContext context) {
    try {
      
    } catch (e) {
      
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/venues/repo/venues_repo.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';

import '../../../../application/payment/model/payment_from.dart';
import '../../../../application/venue_menu/model/venue_menu_model.dart';

class VenueMenuController extends GetxController {
  final int venueId;
  VenueMenuController({required this.venueId});

  final categories = <String>['All'].obs;
  final menuList = <VenueMenuModel>[].obs;
  final isVenueMenuLoading = false.obs;

  final VenuesRepo venueRepo = VenuesRepo();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isVenueMenuLoading.value = true;
    await fetchVenueMenuCategories();
    await fetchVenueMenu();
    isVenueMenuLoading.value = false;
  }

  Future<void> fetchVenueMenuCategories() async {
    try {
      final response = await venueRepo.getVenueMenuCategories();
      categories.value = response;
    } catch (e, stack) {
      debugPrint("Error fetching venue menu: $e");
      debugPrintStack(stackTrace: stack);
    }
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

  Future<void> checkoutToPayment(
    BuildContext context,
    Map<String, dynamic> payload,
  ) async {
    // send checkout payload to server
    try {
      LoadingDialog.show(context);
      final resp = await venueRepo.createMyMenuOrder(payload);
      if (context.mounted) {
        context.push(
          "/payment-screen",
          extra: PaymentFromArg(
            url: resp.checkoutUrl,
            venueId: venueId,
            fromScreen: FromScreen.menuBooking,
          ),
        );
        return;
      }
    } catch (e, stack) {
      debugPrint('Error during checkout: $e');
      debugPrintStack(stackTrace: stack);
      Get.snackbar(
        'Checkout error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

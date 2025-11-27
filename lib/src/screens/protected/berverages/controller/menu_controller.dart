import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/venues/repo/venues_repo.dart';

import '../../../../application/venue_menu/model/venue_menu_model.dart';

class FoodMenuController extends GetxController {
  final int id;
  FoodMenuController({required this.id});

  RxList<VenueMenuModel> foodMenu = <VenueMenuModel>[].obs;
  RxList<VenueMenuModel> selectedFoods = <VenueMenuModel>[].obs;

  final VenuesRepo venuesRepo = VenuesRepo();

  @override
  void onInit() {
    super.onInit();
    fetchFoodMenu();
  }

  Future<void> fetchFoodMenu() async {
    try {
      final response = await venuesRepo.getVenueMenu(id);
      foodMenu.value = response;
    } catch (e) {
      debugPrint('Error fetching menu: $e');
    }
  }

  void addFoodItem(VenueMenuModel item) {
    selectedFoods.add(item);
  }
}

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/events_model.dart';

import '../../../../application/favourite/repo/favourite_repo.dart';

class FavouriteController extends GetxController {
  final FavouriteRepo favouriteRepo = FavouriteRepo();
  final favouriteList = <EventsModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getFavouriteList();
  }

  Future<void> getFavouriteList() async {
    try {
      isLoading.value = true;
      final response = await favouriteRepo.getFavourite();
      favouriteList.value = response;
      isLoading.value = false;
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint("Error fetching favourite list: $e");
      debugPrintStack(stackTrace: stack);
    }
  }
}

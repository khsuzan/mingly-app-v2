import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/home/home_repo.dart';
import 'package:mingly/src/application/home/model/featured_model.dart';

class HomeController extends GetxController {
  final RxBool isFeaturedSectionLoading = false.obs;

  final HomeRepo homeRepo = HomeRepo();

  final RxList<FeaturedModel> featuredItems = <FeaturedModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedSection();
  }

  Future<void> fetchFeaturedSection() async {
    try {
      isFeaturedSectionLoading.value = true;
      final response = await homeRepo.getFeatured();
      debugPrint('Featured Section Response: $response');
      featuredItems.assignAll(response);
    } catch (e) {
      // Handle errors if necessary
    } finally {
      isFeaturedSectionLoading.value = false;
    }
  }
}

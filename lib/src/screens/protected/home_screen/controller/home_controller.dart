import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/application/home/home_repo.dart';
import 'package:mingly/src/application/home/model/featured_model.dart';
import 'package:mingly/src/application/profile/model/profile_model.dart';
import 'package:mingly/src/application/profile/repo/profile_repo.dart';

import '../../../../application/home/model/leader_board_model.dart';
import '../../../../application/venues/model/venues_model.dart';

class HomeController extends GetxController {
  final RxBool isFeaturedSectionLoading = false.obs;
  final RxBool isProfileLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  final HomeRepo homeRepo = HomeRepo();
  final ProfileRepo profileRepo = ProfileRepo();

  final Rx<ProfileModel> profile = ProfileModel().obs;
  final RxList<FeaturedModel> featuredItems = <FeaturedModel>[].obs;
  final RxList<VenuesModel> featuredVenues = <VenuesModel>[].obs;
  final RxList<EventsModel> popularEvents = <EventsModel>[].obs;
  final RxList<LeaderBoardModel> topSpendersList = <LeaderBoardModel>[].obs;
  final RxList<EventsModel> recommendationEvents = <EventsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileInfo();
    fetchHomeData();
  }

  Future<void> fetchProfileInfo() async {
    try {
      isProfileLoading.value = true;
      final response = await profileRepo.fetchProfile();
      debugPrint('Profile Section Response: $response');
      profile.value = response;
    } catch (e) {
      // Handle errors if necessary
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> fetchHomeData() async {
    debugPrint('Home data fetch initiated');
    isRefreshing.value = true;
    await fetchFeaturedSection();
    await fetchFeaturedVenues();
    await fetchTopSpenders();
    await fetchRecommendationEvents();
    isRefreshing.value = false;
    debugPrint('Home data fetch completed');
  }

  Future<void> fetchFeaturedSection() async {
    try {
      final response = await homeRepo.getFeatured();
      debugPrint('Featured Section Response: $response');
      featuredItems.value = response;
    } catch (e, stack) {
      debugPrint('Error fetching featured section: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> fetchFeaturedVenues() async {
    try {
      final response = await homeRepo.getFeaturedVenues();
      debugPrint('Featured Venues Response: $response');
      featuredVenues.value = response;
    } catch (e, stack) {
      debugPrint('Error fetching featured venues: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> fetchPopularEvents() async {
    try {
      final response = await homeRepo.getPopularEvents();
      debugPrint('Popular Events Response: $response');
      popularEvents.value = response;
    } catch (e) {
      debugPrint('Error fetching popular events: $e');
    }
  }

  Future<void> fetchTopSpenders() async {
    try {
      final response = await homeRepo.getLeaderBoard();
      debugPrint('topSpendersList Response: $response');
      topSpendersList.value = response;
    } catch (e, stack) {
      debugPrint('Error fetching topSpendersList events: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> fetchRecommendationEvents() async {
    try {
      final response = await homeRepo.getRecommendation();
      debugPrint('Recommendation Events Response: $response');
      recommendationEvents.value = response.take(3).toList();
    } catch (e, stack) {
      debugPrint('Error fetching recommendation events: $e');
      debugPrintStack(stackTrace: stack);
    }
  }
}

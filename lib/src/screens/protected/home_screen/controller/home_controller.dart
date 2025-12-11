import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/application/home/home_repo.dart';
import 'package:mingly/src/application/home/model/featured_model.dart';
import 'package:mingly/src/application/profile/model/profile_model.dart';
import 'package:mingly/src/application/profile/repo/profile_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../application/home/model/leader_board_model.dart';
import '../../../../application/venues/model/venues_model.dart';

class HomeController extends GetxController {
  final RxBool isFeaturedSectionLoading = false.obs;
  final RxBool isProfileLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool _profileDialogShown = false.obs;

  final HomeRepo homeRepo = HomeRepo();
  final ProfileRepo profileRepo = ProfileRepo();

  // Callback to receive context from UI
  Function(BuildContext)? _onProfileCheckRequired;
  BuildContext? _currentBuildContext;

  final Rx<ProfileModel> profile = ProfileModel().obs;
  final RxList<FeaturedModel> featuredItems = <FeaturedModel>[].obs;
  final RxList<VenuesModel> featuredVenues = <VenuesModel>[].obs;
  final RxList<LeaderBoardModel> topSpendersList = <LeaderBoardModel>[].obs;
  final RxList<EventsModel> recommendationEvents = <EventsModel>[].obs;

  RxString userLocation = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
    fetchUserLocationShared();

    // Listen to profile changes and trigger dialog if incomplete
    ever(profile, (_) {
      _checkAndTriggerProfileDialog();
    });

    ever(userLocation, (callback) {
      fetchRecommendationEvents(userLocation.value);
      fetchFeaturedVenues(userLocation.value);
    });
  }

  /// Set the callback to show profile dialog - called from UI
  void setProfileCheckCallback(Function(BuildContext) callback) {
    _onProfileCheckRequired = callback;
  }

  /// Update the current build context - called from UI
  void updateBuildContext(BuildContext context) {
    _currentBuildContext = context;
  }

  /// Handle featured item tap - navigate based on type
  void handleFeaturedItemTap(FeaturedModel item, GoRouter router) {
    if (item.imageableType == "venues" &&
        item.imageable?.runtimeType.toString() == "ImageableVenue") {
      final extra = (item.imageable as ImageableVenue?)?.toVenuesModel();
      router.push("/venue-detail", extra: extra);
    } else if (item.imageableType == "eevents" &&
        item.imageable?.runtimeType.toString() == "ImageableEvent") {
      final extra = (item.imageable as ImageableEvent?)?.toEventsModel();
      router.push("/event-detail", extra: extra);
    }
  }

  /// Check profile completion and trigger dialog if needed
  void _checkAndTriggerProfileDialog() {
    if (_isProfileComplete()) {
      // Profile is complete, reset the flag so dialog can show again if needed
      _profileDialogShown.value = false;
      return;
    }

    // Profile is incomplete - show dialog if not already shown
    if (!_profileDialogShown.value) {
      _profileDialogShown.value = true;
      // Call the callback with context from the UI
      _onProfileCheckRequired?.call(_currentBuildContext!);
    }
  }

  /// Check if profile is complete
  bool _isProfileComplete() {
    final fullName = profile.value.data?.fullName;
    final avatar = profile.value.data?.avatar;

    return (fullName != null && fullName.isNotEmpty) &&
        (avatar != null && avatar.isNotEmpty);
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
    fetchProfileInfo();
    await fetchFeaturedSection();
    await fetchFeaturedVenues(userLocation.value);
    await fetchTopSpenders();
    await fetchRecommendationEvents(userLocation.value);
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

  Future<void> fetchFeaturedVenues(String location) async {
    try {
      final response = await homeRepo.getFeaturedVenues(location);
      debugPrint('Featured Venues Response: $response');
      featuredVenues.value = response;
    } catch (e, stack) {
      debugPrint('Error fetching featured venues: $e');
      debugPrintStack(stackTrace: stack);
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

  Future<void> fetchRecommendationEvents(String location) async {
    if (location.isEmpty) {
      debugPrint('Location is empty, skipping recommendation fetch');
      recommendationEvents.clear();
      return;
    }
    try {
      final response = await homeRepo.getRecommendation(location);
      debugPrint('Recommendation Events Response: $response');
      recommendationEvents.value = response.take(3).toList();
    } catch (e, stack) {
      debugPrint('Error fetching recommendation events: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  void setLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_location', location);
    userLocation.value = location;
  }

  void fetchUserLocationShared() {
    SharedPreferences.getInstance().then((prefs) {
      String? location = prefs.getString('user_location');
      if (location != null && location.isNotEmpty) {
        userLocation.value = location;
      }
    });
  }
}

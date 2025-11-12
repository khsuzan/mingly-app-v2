import 'package:get/get.dart';
import 'package:mingly/src/application/venues/model/venues_model.dart';

import '../../../../application/venues/repo/venues_repo.dart';

class VenueListController extends GetxController {
  VenuesRepo venuesRepo = VenuesRepo();

  RxBool isLoading = false.obs;

  RxList<VenuesModel> venuesList = <VenuesModel>[].obs;
  Rx<VenueListFilters> filters = VenueListFilters().obs;

  @override
  void onInit() {
    super.onInit();
    fetchVenues();
  }

  Future<void> fetchVenues() async {
    isLoading.value = true;
    try {
      final response = await venuesRepo.getVenues();
      venuesList.value = response;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }
}

class VenueListFilters {
  final String? query;
  final String? type;
  final String? country;
  final String? city;
  VenueListFilters({this.query, this.type, this.country, this.city});
}

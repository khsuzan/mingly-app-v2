import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/venues/model/venues_model.dart';

import '../../../../application/venues/repo/venues_repo.dart';
import '../data/venue_type_data.dart';

class VenueListController extends GetxController {
  VenuesRepo venuesRepo = VenuesRepo();

  RxBool isLoading = false.obs;

  RxList<VenuesModel> venuesList = <VenuesModel>[].obs;
  Rx<VenueListFilters> filters = VenueListFilters().obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchVenues();
  }
  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> fetchVenues() async {
    isLoading.value = true;
    try {
      final response = await venuesRepo.getVenues(
        filters.value.toQueryParams(),
      );
      venuesList.value = response;
      isLoading.value = false;
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint('Error fetching venues: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  void queryChange(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      filters.update((val) {
        val?.query = query;
      });
      fetchVenues();
    });
  }

  void setCity(String city) {
    filters.update((val) {
      val?.city = city;
    });
    fetchVenues();
  }

  void setCountry(String country) {
    filters.update((val) {
      val?.country = country;
    });
    fetchVenues();
  }

  void setType(String type) {
    filters.update((val) {
      val?.type = type;
    });
    fetchVenues();
  }
}

class VenueListFilters {
  String? query;
  String? type;
  String? country;
  String? city;
  VenueListFilters({this.query, this.type, this.country, this.city});

  String toQueryParams() {
    final params = <String>[];
    if (query != null && query!.isNotEmpty) {
      params.add('name=$query');
    }
    if (type != null && type!.isNotEmpty) {
      final venueTypeValue =
          venueTypes.firstWhereOrNull(
            (element) => element['value'] == type,
          )?['label'] ??
          '';
      params.add('venue_type=$venueTypeValue');
    }
    if (country != null && country!.isNotEmpty) {
      params.add('country=$country');
    }
    if (city != null && city!.isNotEmpty) {
      params.add('city=$city');
    }
    return params.join('&');
  }
}

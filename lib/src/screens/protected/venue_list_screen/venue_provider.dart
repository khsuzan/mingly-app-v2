import 'package:flutter/material.dart';

class VenueProvider extends ChangeNotifier {
  // List<VenuesModel> venuesList = [];
  // List<VenuesModel> venuesFeaturedList = [];
  // List<VenueMenuModel> venueMenuList = [];

  // Future<void> getVenuesList() async {
  //   final response = await VenuesRepo().getVenues("");

  //   if (response.isNotEmpty) {
  //     List<VenuesModel> data = response;
  //     venuesList.clear();
  //     for (var e in data) {
  //       venuesList.add(e);
  //     }
  //   }
  //   notifyListeners();
  // }

  // Future<void> getFeaturedVenuesList() async {
  //   final response = await VenuesRepo().getFeaturedVenues();

  //   if (response.isNotEmpty) {
  //     List<VenuesModel> data = response;
  //     venuesFeaturedList.clear();
  //     for (var e in data) {
  //       venuesFeaturedList.add(e);
  //     }
  //   }
  //   notifyListeners();
  // }

  // String getVenueId(String name) {
  //   try {
  //     final venue = venuesList.firstWhere(
  //       (venue) => venue.name == name,
  //       orElse: () => VenuesModel(id: 0),
  //     );
  //     return venue.id.toString();
  //   } catch (e) {
  //     return '';
  //   }
  // }

  // VenuesModel selectedVenueData = VenuesModel(id: 0);

  // var isMenuList = false;
  // void toggleMenuList() {
  //   isMenuList = !isMenuList;
  //   notifyListeners();
  // }

  // void selectedVenue(int? id) {
  //   selectedVenueData = VenuesModel(id: 0);
  //   selectedVenueData = venuesList.firstWhere((venue) => venue.id == id);
  //   notifyListeners();
  // }

  // String getMenuName(int id) {
  //   return venueMenuList.firstWhere((e) => e.id == id).name.toString();
  // }

  // String getMenuPrice(int id) {
  //   return venueMenuList.firstWhere((e) => e.id == id).price.toString();
  // }
}

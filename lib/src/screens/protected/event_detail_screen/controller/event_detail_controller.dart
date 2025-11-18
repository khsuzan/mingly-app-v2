import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/event_details_model.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';
import 'package:mingly/src/components/custom_snackbar.dart';

import '../../../../application/venues/model/venues_model.dart';
import '../../../../components/custom_loading_dialog.dart';

class EventDetailController extends GetxController {
  final String id;
  final Rxn<VenuesModel> venue = Rxn<VenuesModel>();
  final detail = EventDetailsModel().obs;
  final EventsRepo eventsRepo = EventsRepo();
  final isFavourite = false.obs;

  EventDetailController({required this.id});

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
    fetchEventVenue();
    fetchIfFavourite();
  }

  Future<void> addToFavourite(BuildContext context, String id) async {
    try {
      LoadingDialog.show(context);
      await eventsRepo.addToFavorites(id);
      isFavourite.value = true;
      if (context.mounted) {
        CustomSnackbar.show(context, message: 'Added to favourites');
        LoadingDialog.hide(context);
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (context.mounted) LoadingDialog.hide(context);
    }
  }

  Future<void> fetchEventVenue() async {
    try {
      final response = await eventsRepo.getEventVenue(int.parse(id));
      venue.value = response;
    } catch (e, stack) {
      debugPrint("Error: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> fetchIfFavourite() async {
    try {
      debugPrint("Fetching if favourite for event id: $id");
      await eventsRepo.getEventInfavourite(int.parse(id));
      isFavourite.value = true;
    } catch (e, stack) {
      isFavourite.value = false;
      debugPrint("Error: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> removeFromFavourite(BuildContext context, String id) async {
    try {
      LoadingDialog.show(context);
      debugPrint("Fetching if favourite for event id: $id");
      await eventsRepo.deleteFromfavourite(int.parse(id));
      isFavourite.value = false;
      if (context.mounted) LoadingDialog.hide(context);
    } catch (e, stack) {
      isFavourite.value = true;
      if (context.mounted) LoadingDialog.hide(context);
      debugPrint("Error: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  void fetchDetail() async {
    try {
      final response = await eventsRepo.getEventsDetails(id);
      detail.value = response;
    } catch (e) {
      debugPrint("Error fetching event details: $e");
    }
  }
}

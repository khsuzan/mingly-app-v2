import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mingly/src/components/custom_snackbar.dart';

import '../../../../application/reservation/repo/reservation_repo.dart';
import '../../../../components/custom_loading_dialog.dart';

class VenueReserveController extends GetxController {
  final reservationRepo = ReservationRepo();

  DateTime? date;
  int personCount = 1;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  // Store reservation data in a map
  Map<String, dynamic> get reservationData {
    String? formattedDate;
    if (date != null) {
      formattedDate = DateFormat('yyyy-MM-dd').format(date!);
    }

    String? startTime;
    if (fromTime != null) {
      startTime = _formatTime24(fromTime!);
    }

    String? endTime;
    if (toTime != null) {
      endTime = _formatTime24(toTime!);
    }

    return {
      'date': formattedDate,
      'start_time': startTime,
      'end_time': endTime,
      'persons': personCount,
    };
  }

  String _formatTime24(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  void updateDate(DateTime newDate) {
    date = newDate;
    update();
  }

  void updatePersonCount(int count) {
    personCount = count;
    update();
  }

  void updateFromTime(TimeOfDay time) {
    fromTime = time;
    update();
  }

  void updateToTime(TimeOfDay time) {
    toTime = time;
    update();
  }

  Future<void> requestForReserveVenue(BuildContext context, int venueId) async {
    if (personCount < 1 || date == null || fromTime == null || toTime == null) {
      CustomSnackbar.show(
        context,
        message:
            "Please fill in all the fields before submitting the reservation.",
      );
      return;
    }
    try {
      LoadingDialog.show(context);
      await reservationRepo.requestReservation(reservationData, venueId);

      if (context.mounted) {
        LoadingDialog.hide(context);
        CustomSnackbar.show(
          context,
          message:
              "We have received your reservation request. Thank you!. We will get back to you soon.",
        );
        context.pop();
      }
    } catch (e, stack) {
      debugPrint("Error making reservations: $e");
      debugPrintStack(stackTrace: stack);
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }
}

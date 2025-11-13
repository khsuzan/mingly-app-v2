import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VenueReserveController extends GetxController {
	DateTime? date;
	int personCount = 1;
	TimeOfDay? fromTime;
	TimeOfDay? toTime;

	// Store reservation data in a map
	Map<String, dynamic> get reservationData => {
		'date': date?.toIso8601String(),
		'person_count': personCount,
    // requires: import 'package:intl/intl.dart';
    'from_time': fromTime != null
      ? DateFormat.jm().format(DateTime(2000, 1, 1, fromTime!.hour, fromTime!.minute))
      : null,
    'to_time': toTime != null
      ? DateFormat.jm().format(DateTime(2000, 1, 1, toTime!.hour, toTime!.minute))
      : null,
	};

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

	Future<void> submitReservation(int venueId) async {
		// Example API call using http package
		// Replace with your actual endpoint and logic
		final url = 'https://your.api/venue/$venueId/reserve';
		final body = reservationData;
		// import 'package:http/http.dart' as http; at the top of your file
		// final response = await http.post(Uri.parse(url), body: body);
		// Handle response
		// if (response.statusCode == 200) {
		//   // Success logic
		// } else {
		//   // Error logic
		// }
	}
}
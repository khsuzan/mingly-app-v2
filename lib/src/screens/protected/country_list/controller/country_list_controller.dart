import 'package:get/get.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

class CountryListController extends GetxController {
	final countryCityMap = <String, List<String>>{}.obs;
	final countries = <String>[].obs;
	final filteredCountries = <String>[].obs;
	final loading = true.obs;
	final search = ''.obs;

	@override
	void onInit() {
		super.onInit();
		loadCountryCity();
	}

	Future<void> loadCountryCity() async {
		loading.value = true;
		final data = await rootBundle.loadString('lib/assets/country_city.json');
		final Map<String, dynamic> jsonMap = json.decode(data);
		final map = <String, List<String>>{};
		jsonMap.forEach((k, v) {
			map[k] = List<String>.from(v);
		});
		countryCityMap.value = map;
		countries.value = map.keys.toList()..sort();
		filteredCountries.value = countries;
		loading.value = false;
	}

	void onSearch(String value) {
		search.value = value;
		filteredCountries.value = countries
				.where((c) => c.toLowerCase().contains(value.toLowerCase()))
				.toList();
	}
}
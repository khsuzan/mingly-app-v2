import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryCityDropdown extends StatefulWidget {
  final Function(String?, String?) onChanged;

  const CountryCityDropdown({super.key, required this.onChanged});

  @override
  State<CountryCityDropdown> createState() => _CountryCityDropdownState();
}

class _CountryCityDropdownState extends State<CountryCityDropdown> {
  Map<String, dynamic> countryCityData = {};
  String? selectedCountry;
  String? selectedCity;
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    loadCountryCityData();
  }

  Future<void> loadCountryCityData() async {
    final jsonString = await rootBundle.loadString(
      'lib/assets/country_city.json',
    );
    final data = json.decode(jsonString) as Map<String, dynamic>;
    setState(() {
      countryCityData = data;
    });
  }

  void _notifyParent() {
    widget.onChanged(selectedCountry, selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // --- Country Dropdown ---
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                menuWidth: 0.8.sw,
                dropdownColor: Colors.grey.shade900,
                value: selectedCountry,
                hint: const Text(
                  "Country",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
                isExpanded: true,
                items: countryCityData.keys.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(
                      country,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                    selectedCity = null;
                    cities = List<String>.from(countryCityData[value]!);
                  });
                  _notifyParent();
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // --- City Dropdown ---
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                menuWidth: 0.8.sw,
                dropdownColor: Colors.grey.shade900,
                value: selectedCity,
                hint: const Text(
                  "City",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
                isExpanded: true,
                items: cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(
                      city,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                  _notifyParent();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

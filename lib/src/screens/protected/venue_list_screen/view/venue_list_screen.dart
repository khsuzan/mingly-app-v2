import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/couttry_city_widget.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/venue_list_screen/controller/venue_list_controller.dart';

import '../data/venue_type_data.dart';

class VenueListScreen extends StatelessWidget {
  const VenueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<VenueListController>(
      init: VenueListController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: const Text('Venues', style: TextStyle(color: Colors.white)),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                DefaultTextStyle(
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: theme.colorScheme.primary.withAlpha(100),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 40,
                          child: Obx(
                            () => DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                dropdownColor: Colors.grey.shade900,
                                value: controller.filters.value.type,
                                menuWidth: 0.8.sw,
                                menuMaxHeight: 1.0.sh,
                                hint: const Text(
                                  "Venue Type",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white),
                                ),
                                isExpanded: true,
                                items: venueTypes.map((type) {
                                  return DropdownMenuItem<String>(
                                    value: type['value'],
                                    child: Text(
                                      type['label']!,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller.setType(value!);
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 60,
                          child: CountryCityDropdown(
                            onChanged: (country, city) {
                              controller.setCountry(country ?? "");
                              controller.setCity(city ?? "");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 🔍 Search Field
                Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: Color(0xFF2E2D2C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: TextEditingController(),
                      onChanged: (value) {
                        controller.queryChange(value);
                      },
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white70,
                          size: 24,
                        ),
                        hintText: 'Search venues...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 📋 Venue list (filtered)
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Expanded(
                    child: controller.venuesList.isEmpty
                        ? Center(
                            child: Text(
                              "No venues found",
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              controller.fetchVenues();
                            },
                            child: ListView.builder(
                              itemCount: controller.venuesList.length,
                              itemBuilder: (context, index) {
                                final venue = controller.venuesList[index];
                                return _VenueCard(
                                  onTap: () {
                                    context.push("/venue-detail", extra: venue);
                                  },
                                  image:
                                      venue.images!.isEmpty ||
                                          venue.images!.first.imageUrl == null
                                      ? "https://www.directmobilityonline.co.uk/assets/img/noimage.png"
                                      : "${AppUrls.imageUrl}${venue.images!.first.imageUrl!}",
                                  title: venue.name ?? '',
                                  location: venue.city ?? '',
                                  time: venue.openingHours == null
                                      ? ""
                                      : "${venue.openingHours!.open} - ${venue.openingHours!.close}",
                                );
                              },
                            ),
                          ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ✅ Venue Card Widget
class _VenueCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String time;
  final Function()? onTap;

  const _VenueCard({
    required this.image,
    required this.title,
    required this.location,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: const Color(0xFF2E2D2C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    image,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              location,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white54,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                time,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

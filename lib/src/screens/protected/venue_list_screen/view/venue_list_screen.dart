import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/couttry_city_widget.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/event_list_screen/events_provider.dart';
import 'package:mingly/src/screens/protected/venue_list_screen/controller/venue_list_controller.dart';
import 'package:mingly/src/screens/protected/venue_list_screen/venue_provider.dart';
import 'package:provider/provider.dart';

class VenueListScreen extends StatefulWidget {
  const VenueListScreen({super.key});

  @override
  State<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  String countryValue = "";

  String cityValue = "";
  String? selectedVenueType;

  final List<Map<String, String>> venueTypes = [
    {"value": "rooftop_sky_lounge", "label": "Rooftop / Sky Lounge"},
    {"value": "nightclub_bar", "label": "Nightclub / Bar"},
    {"value": "beach_club", "label": "Beach Club"},
    {"value": "ballroom_banquet_hall", "label": "Ballroom / Banquet Hall"},
    {"value": "private_villa_mansion", "label": "Private Villa / Mansion"},
    {"value": "yacht_cruise", "label": "Yacht / Cruise"},
    {"value": "restaurant", "label": "Restaurant"},
    {"value": "lounge", "label": "Lounge"},
    {"value": "poolside_venue", "label": "Poolside Venue"},
    {"value": "garden_outdoor_terrace", "label": "Garden / Outdoor Terrace"},
    {"value": "hotel_conference_room", "label": "Hotel Conference Room"},
    {"value": "convention_center", "label": "Convention Center"},
    {"value": "co_working_space", "label": "Co-working Space"},
    {"value": "exhibition_hall", "label": "Exhibition Hall"},
    {"value": "auditorium_theatre", "label": "Auditorium / Theatre"},
    {"value": "private_members_club", "label": "Private Members' Club"},
    {"value": "luxury_hotel_suite", "label": "Luxury Hotel Suite"},
    {"value": "chateau_estate", "label": "Chateau / Estate"},
    {"value": "art_gallery_museum", "label": "Art Gallery / Museum"},
    {"value": "penthouse", "label": "Penthouse"},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(VenueListController());

    // final venuesProvider = context.watch<VenueProvider>();
    // final eventProvider = context.watch<EventsProvider>();

    // Filtered venue list
    // final filteredVenues = venuesProvider.venuesList.where((venue) {
    //   final name = venue.name?.toLowerCase() ?? '';
    //   final address = venue.address?.toLowerCase() ?? '';
    //   final matchesSearch =
    //       name.contains(searchQuery) || address.contains(searchQuery);

    //   final matchesVenueType =
    //       selectedVenueType == null ||
    //       venue.address?.toLowerCase() == selectedVenueType!.toLowerCase();

    //   final matchesCountry =
    //       countryValue.isEmpty ||
    //       (venue.country?.toLowerCase() == countryValue.toLowerCase());

    //   final matchesCity =
    //       cityValue.isEmpty ||
    //       (venue.city?.toLowerCase() == cityValue.toLowerCase());

    //   return matchesSearch && matchesVenueType && matchesCountry && matchesCity;
    // }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Colors.grey.shade900,
                          value: selectedVenueType,
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
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedVenueType = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 60,
                      child: CountryCityDropdown(
                        onChanged: (country, city) {
                          setState(() {
                            countryValue = country ?? "";
                            cityValue = city ?? "";
                          });
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
                  controller: _searchController,
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
                        onRefresh: () async{
                          controller.fetchVenues();
                        },
                      child: ListView.builder(
                          itemCount: controller.venuesList.length,
                          itemBuilder: (context, index) {
                            final venue = controller.venuesList[index];
                            return _VenueCard(
                              onTap: () {
                                // venuesProvider.selectedVenue(venue.id);
                                // await eventProvider.getEvetListVuneWise(
                                //   venue.id!.toInt(),
                                // );
                                // await venuesProvider.getVenueMenuList(
                                //   venue.id!.toInt(),
                                // );
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

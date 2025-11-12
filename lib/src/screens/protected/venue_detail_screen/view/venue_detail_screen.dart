import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mingly/src/application/venues/model/venues_model.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/berverages/widget/menu_card.dart';
import 'package:mingly/src/screens/protected/event_list_screen/events_provider.dart';
import 'package:mingly/src/screens/protected/venue_detail_screen/controller/venue_detail_controller.dart';
import 'package:mingly/src/screens/protected/venue_detail_screen/menu_card.dart';
import 'package:mingly/src/screens/protected/venue_list_screen/venue_provider.dart';
import 'package:provider/provider.dart';

class VenueDetailScreen extends StatelessWidget {
  final VenuesModel venue;
  const VenueDetailScreen({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VenueDetailController(venue));

    final provider = context.watch<VenueProvider>();
    final eventProvider = context.watch<EventsProvider>();
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          provider.selectedVenueData.name ?? 'Venue Detail',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        // actions: [
        //   InkWell(
        //     onTap: () {},
        //     child: DecoratedBox(
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         shape: BoxShape.circle,
        //       ),
        //       child: const Icon(Icons.star_border, color: Colors.black),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: venue.images == null || venue.images!.isEmpty
                      ? Image.network(
                          "https://www.directmobilityonline.co.uk/assets/img/noimage.png",
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : PageView.builder(
                          itemCount: venue.images!.length,
                          itemBuilder: (context, index) {
                            final image = venue.images![index];
                            return Image.network(
                              "${AppUrls.imageUrl}${image.imageUrl}",
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey[500],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 16),

              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFF8E7A72), width: 0.4),
                    bottom: BorderSide(color: Color(0xFF8E7A72), width: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        provider.toggleMenuList();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.grid_view, color: Color(0xFFD1B26F)),
                            SizedBox(width: 8),
                            Text(
                              'Event List',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 35, width: 1, color: Color(0xFF8E7A72)),
                    InkWell(
                      onTap: () {
                        provider.toggleMenuList();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.menu_book, color: Color(0xFFD1B26F)),
                            SizedBox(width: 8),
                            Text(
                              'View Menu',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              //event list and other info
              provider.isMenuList == false
                  ? Column(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.location_on, color: Color(0xFFD1B26F)),
                            SizedBox(width: 8),
                            Text(
                              'Address',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${venue.address.toString()}, ${venue.city.toString()}, ${venue.state.toString()}, ${venue.country.toString()}",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Icon(Icons.access_time, color: Color(0xFFD1B26F)),
                            SizedBox(width: 8),
                            Text(
                              'Opening hour',
                              style: TextStyle(
                                color: Color(0xFFD1B26F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Text(
                              'Friday',
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(width: 16),
                            Text(
                              '19:00 PM - 01:00 AM',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Icon(Icons.group, color: Color(0xFFD1B26F)),
                            SizedBox(width: 8),
                            Text(
                              'Capacity',
                              style: TextStyle(
                                color: Color(0xFFD1B26F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              provider.selectedVenueData.capacity.toString(),
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Popular Events',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'See All',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          return controller.eventsList.isEmpty
                              ? Container()
                              : Column(
                                  children: List.generate(
                                    controller.eventsList.length,
                                    (index) {
                                      return InkWell(
                                        onTap: () async {
                                          context.push(
                                            "/event-detail",
                                            extra: controller.eventsList[index],
                                          );
                                        },
                                        child: _PopularEventCard(
                                          image:
                                              controller
                                                          .eventsList[index]
                                                          .images
                                                          ?.isEmpty ==
                                                      true ||
                                                  controller
                                                          .eventsList[index]
                                                          .images
                                                          ?.firstOrNull
                                                          ?.imageUrl ==
                                                      null
                                              ? "https://www.directmobilityonline.co.uk/assets/img/noimage.png"
                                              : "${AppUrls.imageUrl}${eventProvider.eventsListVenueWise[index].images!.first.imageUrl}",
                                          name: eventProvider
                                              .eventsListVenueWise[index]
                                              .eventName
                                              .toString(),
                                        ),
                                      );
                                    },
                                  ),
                                );
                        }),
                        const SizedBox(height: 32),
                      ],
                    )
                  : provider.venueMenuList.isEmpty
                  ? Center(child: Text("No menu available"))
                  : Column(
                      children: List.generate(provider.venueMenuList.length, (
                        index,
                      ) {
                        final item = provider.venueMenuList[index];
                        return MenuCardVenue(
                          item: item,
                          onTap: () {
                            // Example: navigate to detail page or show details modal.
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(item.name!),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      AppUrls.imageUrl + item.image!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 120,
                                                height: 120,
                                                color: Colors.grey[500],
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                ),
                                              ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(item.description!),
                                    const SizedBox(height: 8),
                                    Text('Quantity: ${item.quantity}'),
                                    Text(
                                      'Price: ${double.parse(item.price!).toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),
              provider.venueMenuList.isEmpty && provider.isMenuList
                  ? SizedBox(height: 32)
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD1B26F)),
                          foregroundColor: Color(0xFFD1B26F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          openMapToAddress(
                            "${provider.selectedVenueData.address.toString()}, ${provider.selectedVenueData.city.toString()}, ${provider.selectedVenueData.state.toString()}, ${provider.selectedVenueData.country.toString()}",
                          );
                        },
                        child: const Text('Direction'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE7B9),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // context.push("/event-detail");
                          //  eventProvider.addReserve(eventProvider.eventsListVenueWise[index].id!.toInt());
                        },
                        child: Text(
                          'Reserve',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF0E0F11),
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                            height: 1.43,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopularEventCard extends StatelessWidget {
  String name;
  String image;

  _PopularEventCard({Key? key, required this.image, required this.name})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900, // fallback background color
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade800, width: 1),
                  ),
                  clipBehavior:
                      Clip.antiAlias, // ensures image respects borderRadius
                  child: image != null && image.isNotEmpty
                      ? Image.network(
                          image,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey.shade600,
                              size: 40,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade600,
                            size: 40,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Dance',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const Spacer(),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.favorite_border,
                            color: Color(0xFFFFE7B9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  name!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'THU 26 May, 09:00 - 10:00',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey.shade800,
                          child: Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '+15',
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$30.00',
                      style: TextStyle(
                        color: const Color(0xFFE6B863),
                        fontSize: 14,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

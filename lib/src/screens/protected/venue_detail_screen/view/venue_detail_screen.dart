import 'dart:convert';
import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/venues/model/venues_model.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';

class VenueDetailScreen extends StatelessWidget {
  final VenuesModel venue;
  const VenueDetailScreen({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(VenueDetailController(venue));
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
          'Venue Detail',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 0.26.sh,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CarouselSlider.builder(
                      itemCount: venue.images?.length ?? 0,
                      options: CarouselOptions(
                        height: 0.26.sh,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        viewportFraction: 0.9,
                        enlargeFactor: 0.2,
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(
                                AppUrls.imageUrl +
                                    venue.images![index].imageUrl.toString(),
                              ),
                              fit: BoxFit.cover,
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
                          context.push('/event-list', extra: venue.id);
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
                          // provider.toggleMenuList();
                          context.push("/venue-menu", extra: venue.id);
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      venue.name ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Address',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
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
                      children: [
                        Icon(
                          Icons.access_time,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Opening Hours',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final openStr = venue.openingHours?.open ?? "";
                        final closeStr = venue.openingHours?.close ?? "";
                        Map<String, dynamic>? openMap;
                        Map<String, dynamic>? closeMap;
                        try {
                          if (openStr.trim().startsWith('{') &&
                              openStr.trim().endsWith('}')) {
                            openMap = jsonDecode(openStr);
                          }
                          if (closeStr.trim().startsWith('{') &&
                              closeStr.trim().endsWith('}')) {
                            closeMap = jsonDecode(closeStr);
                          }
                        } catch (_) {}
                        if (openMap != null && openMap.isNotEmpty) {
                          // Show by day, open - close in 12-hour format
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: openMap.keys.map((day) {
                              final openValue = openMap![day]?.toString() ?? '';
                              final closeValue = closeMap != null
                                  ? closeMap[day]?.toString() ?? ''
                                  : '';
                              final openFormatted = openValue.isNotEmpty
                                  ? formatHourMinuteToAmPm(openValue)
                                  : '';
                              final closeFormatted = closeValue.isNotEmpty
                                  ? formatHourMinuteToAmPm(closeValue)
                                  : '';
                              return Text(
                                '${day[0].toUpperCase()}${day.substring(1)}: $openFormatted - $closeFormatted',
                                style: TextStyle(color: Colors.white70),
                              );
                            }).toList(),
                          );
                        } else {
                          // Fallback: show as range
                          return Text(
                            "${formatHourMinuteToAmPm(openStr)} - ${formatHourMinuteToAmPm(closeStr)}",
                            style: TextStyle(color: Colors.white70),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
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
                          venue.capacity.toString(),
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.description,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Description',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  venue.description ?? '',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 32),
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
                              "${venue.address.toString()}, ${venue.city.toString()}, ${venue.state.toString()}, ${venue.country.toString()}",
                            );
                          },
                          child: const Text('Direction'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Reserve',
                          onPressed: () {
                            context.push("/venue-reserve", extra: venue);
                          },
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
      ),
    );
  }
}

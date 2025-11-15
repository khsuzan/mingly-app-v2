import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/app_urls.dart';
import 'controller/event_detail_controller.dart';

class EventDetailScreen extends StatelessWidget {
  final EventsModel event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(EventDetailController(id: event.id.toString()));
    // final eventProvider = context.watch<EventsProvider>();
    // final venueProvider = context.watch<VenueProvider>();
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD1B26F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          event.eventName.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: const Color(0xFFD1B26F)),
            onPressed: () async {
              LoadingDialog.show(context);
              await controller.addToFavourite(event.id.toString());
              LoadingDialog.hide(context);
            },
          ),
        ],
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: Colors.grey.shade800,
            height: 2,
            width: double.infinity,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image carousel (static for now)
              CarouselSlider.builder(
                itemCount: event.images?.length,
                options: CarouselOptions(
                  height: 0.26.sh,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  viewportFraction: 0.96,
                  enlargeFactor: 0.2,
                  enableInfiniteScroll: false
                ),
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                          AppUrls.imageUrl +
                              (event.images?[index].imageUrl.toString() ?? ''),
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              Text(
                event.eventName.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, color: Color(0xFFD1B26F), size: 18),
                  SizedBox(width: 4),
                  Text(
                    event.venue?.city ?? "",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xFFD1B26F),
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Obx(() {
                    return Text(
                      controller.detail.value.firstSessionDate.toString(),
                      style: TextStyle(color: Colors.white70),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: Color(0xFFD1B26F), size: 18),
                  SizedBox(width: 4),
                  Text(
                    '${formatTimeToAmPm(controller.detail.value.sessionStartTime.toString())} - ${formatTimeToAmPm(controller.detail.value.sessionEndTime.toString())}',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: TextStyle(
                  color: Color(0xFFD1B26F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              Linkify(
                text: event.description ?? '',
                onOpen: (link) async {
                  print('Opening link: ${link.url}');
                  final Uri url = Uri.parse(link.url);

                  // Always use external mode
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
                style: const TextStyle(color: Colors.white),
                linkStyle: const TextStyle(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
              ), // Text(

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD1B26F),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () async {
                      context.push("/ticket-booking", extra: event);
                      // LoadingDialog.show(context);
                      // final status = await eventProvider.getEventTicketList(
                      //   event.id.toString(),
                      // );

                      // LoadingDialog.hide(context);
                      // if (status) {
                      //   context.push("/ticket-booking");
                      // } else {
                      //   CustomSnackbar.show(
                      //     context,
                      //     message: "No tickets available for this event",
                      //     backgroundColor: Colors.red,
                      //   );
                      // }
                    },
                    child: const Text('Book Ticket'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD1B26F),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () async {
                      context.push("/table-booking", extra: event);
                      // LoadingDialog.show(context);
                      // final status = await eventProvider.getTableTicketList(
                      //   eventProvider.eventDetailsModel.firstSessionDate
                      //       .toString(),
                      //   eventProvider.eventDetailsModel.sessionStartTime
                      //       .toString(),
                      // );
                      // await venueProvider.getVenueMenuList(
                      //   int.parse(
                      //     venueProvider.getVenueId(
                      //       eventProvider.selectEventModel.venueName.toString(),
                      //     ),
                      //   ),
                      // );
                      // LoadingDialog.hide(context);
                      // if (status) {
                      //   context.push("/table-booking");
                      // } else {
                      //   CustomSnackbar.show(
                      //     context,
                      //     message: "No tables available for this event",
                      //     backgroundColor: Colors.red,
                      //   );
                      // }
                    },
                    child: const Text('Sofa & Table'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
